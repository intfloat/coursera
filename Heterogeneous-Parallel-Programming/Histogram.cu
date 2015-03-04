// Borrowed from https://github.com/s4lesman, slightly modification

#include    <wb.h>

#define HISTOGRAM_LENGTH 256

__global__ void convertToChar(float * input, unsigned char * ucharInput, int width, int height) {
    int bx = blockIdx.x;  int by = blockIdx.y;
    int tx = threadIdx.x; int ty = threadIdx.y;

    int row = by*blockDim.y+ty;
    int col = bx*blockDim.x+tx;
    int index = row*width + col;

    if(row < height && col < width) {
        ucharInput[index*3]   = (unsigned char) (255 * input[index*3]); //r
        ucharInput[index*3+1] = (unsigned char) (255 * input[index*3+1]); //g
        ucharInput[index*3+2] = (unsigned char) (255 * input[index*3+2]); //b
    }
}

__global__ void convertToGrayScale(unsigned char * ucharImg, unsigned char * grayImg, int width, int height) {
    int bx = blockIdx.x;  int by = blockIdx.y;
    int tx = threadIdx.x; int ty = threadIdx.y;

    int row = by*blockDim.y+ty;
    int col = bx*blockDim.x+tx;
    int index = row*width + col;

    if(row < height && col < width) {
        grayImg[index] = (unsigned char) (0.21*ucharImg[index*3] + 0.71*ucharImg[index*3 + 1] + 0.07*ucharImg[index*3 + 2]);
    }
}

__global__ void hist_eq(unsigned char * deviceCharImg, float * output, float* cdf, float cdfmin, int size) {
    int bx = blockIdx.x;
    int tx = threadIdx.x;
    int i = tx+blockDim.x*bx;

    if(i < size) {
        deviceCharImg[i] = min(max(255*(cdf[deviceCharImg[i]] - cdfmin)/(1 - cdfmin),0.0),255.0);
        output[i] = (float) (deviceCharImg[i]/255.0);
    }
}

__global__ void histo_kernel(unsigned char * buffer, unsigned int * histo, long size) {
    //  compute histogram with a private version in each block
    __shared__ unsigned int histo_private[HISTOGRAM_LENGTH];
    int bx = blockIdx.x;
    int tx = threadIdx.x;
    //  index of current pixel
    int index = tx+bx*blockDim.x;

    //  set initial values of histogram to zero
    if (tx < HISTOGRAM_LENGTH) histo_private[tx] = 0;

    __syncthreads();

    int stride = blockDim.x*gridDim.x;
    atomicAdd(&(histo_private[buffer[index]]), 1);
    __syncthreads();

    //copy private histogram to device histogram
    if(tx < 256) {
        atomicAdd(&(histo[tx]), histo_private[tx]);
    }
}

float prob(int x, int width, int height) {
    return 1.0 * x / (width * height);
}

int main(int argc, char ** argv) {
    wbArg_t args;
    int imageWidth;
    int imageHeight;
    int imageChannels;
    wbImage_t inputImage;
    wbImage_t outputImage;
    float * hostInputImageData;
    float * hostOutputImageData;
    const char * inputImageFile;

    //@@ Insert more code here
    //  device variables
    float * deviceInputImageData;
    float * deviceOutputImageData;
    unsigned char * deviceUCharImage;
    unsigned char * deviceGrayImg;

    args = wbArg_read(argc, argv); /* parse the input arguments */

    inputImageFile = wbArg_getInputFile(args, 0);

    wbTime_start(Generic, "Importing data and creating memory on host");
    inputImage = wbImport(inputImageFile);
    imageWidth = wbImage_getWidth(inputImage);
    imageHeight = wbImage_getHeight(inputImage);
    imageChannels = wbImage_getChannels(inputImage);
    outputImage = wbImage_new(imageWidth, imageHeight, imageChannels);
    wbTime_stop(Generic, "Importing data and creating memory on host");

    //@@ insert code here
    hostInputImageData = wbImage_getData(inputImage);
    hostOutputImageData = wbImage_getData(outputImage);

    //allocate memory for device variables
    cudaMalloc((void **) &deviceInputImageData, imageWidth*imageHeight*imageChannels*sizeof(float));
    cudaMalloc((void **) &deviceOutputImageData, imageWidth*imageHeight*imageChannels*sizeof(float));
    cudaMalloc((void **) &deviceUCharImage, imageWidth*imageHeight*imageChannels*sizeof(unsigned char));
    cudaMalloc((void **) &deviceGrayImg, imageWidth*imageHeight*sizeof(unsigned char));

    cudaMemcpy(deviceInputImageData,
               hostInputImageData,
               imageWidth*imageHeight*imageChannels*sizeof(float),
               cudaMemcpyHostToDevice);

    wbLog(TRACE, "image width: ",imageWidth,", image height: ",imageHeight);

    //@@ insert code here
    dim3 dimBlock(12, 12, 1);
    dim3 dimGrid((imageWidth - 1)/12 + 1, (imageHeight - 1)/12 + 1, 1);

    //convert the image to unsigned char
    convertToChar<<<dimGrid, dimBlock>>>(deviceInputImageData, deviceUCharImage, imageWidth, imageHeight);

    //  need to convert image to grayscale
    convertToGrayScale<<<dimGrid, dimBlock>>>(deviceUCharImage, deviceGrayImg, imageWidth, imageHeight);

    //  allocate histogram host and set initial values of array to zero.
    unsigned int * hostHistogram;
    hostHistogram = (unsigned int *) malloc(HISTOGRAM_LENGTH*sizeof(unsigned int));
    for(int i = 0; i < HISTOGRAM_LENGTH; i++) {
        hostHistogram[i] = 0;
    }

    //  allocation for histogram from host to device
    unsigned int * deviceHistogram;
    cudaMalloc((void **) &deviceHistogram,HISTOGRAM_LENGTH*sizeof(unsigned int));
    cudaMemcpy(deviceHistogram, hostHistogram, HISTOGRAM_LENGTH*sizeof(unsigned int), cudaMemcpyHostToDevice);

    //  size in 1D, gray image should only have one channel
    dim3 histoGrid((imageWidth*imageHeight-1)/HISTOGRAM_LENGTH + 1, 1, 1);
    dim3 histoBlock(HISTOGRAM_LENGTH,1,1);

    //compute the histogram
    histo_kernel<<<histoGrid, histoBlock>>>(deviceGrayImg, deviceHistogram, imageWidth*imageHeight);

    //copy result back to host histogram
    cudaMemcpy(hostHistogram, deviceHistogram, HISTOGRAM_LENGTH*sizeof(unsigned int), cudaMemcpyDeviceToHost);

    //  compute scan operation for histogram
    float * hostCDF;
    hostCDF = (float *)malloc(HISTOGRAM_LENGTH*sizeof(float));
    hostCDF[0] = prob(hostHistogram[0], imageWidth, imageHeight);
    for(int i = 1; i < HISTOGRAM_LENGTH; i++) {
        hostCDF[i] = hostCDF[i-1]+prob(hostHistogram[i],imageWidth,imageHeight);
    }

    //  compute cdfmin
    float cdfmin = hostCDF[0];
    //  copy host cdf to device
    float *deviceCDF;
    cudaMalloc((void **) &deviceCDF, HISTOGRAM_LENGTH*sizeof(float));
    cudaMemcpy(deviceCDF, hostCDF, HISTOGRAM_LENGTH*sizeof(float), cudaMemcpyHostToDevice);

    //  histogram equalization function
    dim3 dimGrid2((imageWidth*imageHeight*imageChannels - 1)/HISTOGRAM_LENGTH + 1, 1, 1);
    dim3 dimBlock2(HISTOGRAM_LENGTH, 1, 1);

    hist_eq<<<dimGrid2, dimBlock2>>>(deviceUCharImage, deviceOutputImageData, deviceCDF, cdfmin, imageWidth*imageHeight*imageChannels);

    //  copy results back to host
    cudaMemcpy(hostOutputImageData, deviceOutputImageData, imageWidth*imageHeight*imageChannels*sizeof(float), cudaMemcpyDeviceToHost);
    wbSolution(args, outputImage);

    cudaFree(deviceUCharImage);
    cudaFree(deviceGrayImg);
    cudaFree(deviceInputImageData);
    cudaFree(deviceOutputImageData);

    free(hostInputImageData);
    free(hostOutputImageData);

    wbImage_delete(outputImage);
    wbImage_delete(inputImage);

    return 0;
}
