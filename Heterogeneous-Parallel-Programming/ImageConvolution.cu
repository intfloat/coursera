#include    <wb.h>


#define wbCheck(stmt) do {                                                    \
        cudaError_t err = stmt;                                               \
        if (err != cudaSuccess) {                                             \
            wbLog(ERROR, "Failed to run stmt ", #stmt);                       \
            wbLog(ERROR, "Got CUDA error ...  ", cudaGetErrorString(err));    \
            return -1;                                                        \
        }                                                                     \
    } while(0)

#define Mask_width  5
#define Mask_radius 2
#define O_TILE_WIDTH 12
#define BLOCK_WIDTH 16

//@@ INSERT CODE HERE
__global__ void convolution_2D_kernel(float* out, float* in, int height,
                                      int width, int channels,
                                      const float *mask) {
    __shared__ float NS[BLOCK_WIDTH][BLOCK_WIDTH][3];   
    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int row_o = blockIdx.y * O_TILE_WIDTH + ty;
    int col_o = blockIdx.x * O_TILE_WIDTH + tx;
    int row_i = row_o - Mask_radius;
    int col_i = col_o - Mask_radius;
    if (row_i >= 0 && row_i < height && col_i >= 0 && col_i < width) {
        for (int cz = 0; cz < 3; ++cz)
        { NS[ty][tx][cz] = in[(row_i * width + col_i) * channels + cz]; }
    }
    else {
        for (int cz = 0; cz < 3; ++cz) NS[ty][tx][cz] = 0.0;
    }

//  ensure all threads have finished loading data
    __syncthreads();

    if (ty < O_TILE_WIDTH && tx < O_TILE_WIDTH) {
        float res[3];
        for (int i = 0; i < 3; ++i) res[i] = 0.0;
        for (int i = 0; i < Mask_width; ++i) {
            for (int j = 0; j < Mask_width; ++j) {
                for (int ch = 0; ch < 3; ++ch) { res[ch] = res[ch] + mask[i * Mask_width + j] * NS[i + ty][j + tx][ch]; }
            }
        }
        __syncthreads();
        for (int i = 0; i < 3; ++i) {
            if (res[i] < 0.0) res[i] = 0.0;
            if (res[i] > 1.0) res[i] = 1.0;
        }
        if (row_o < height && col_o < width)
            for (int ch = 0; ch < 3; ++ch) { out[(row_o * width + col_o) * channels + ch] = res[ch]; }
    }
    // __syncthreads();
    return;
}

int main(int argc, char* argv[]) {
    wbArg_t args;
    int maskRows;
    int maskColumns;
    int imageChannels;
    int imageWidth;
    int imageHeight;
    char * inputImageFile;
    char * inputMaskFile;
    wbImage_t inputImage;
    wbImage_t outputImage;
    float * hostInputImageData;
    float * hostOutputImageData;
    float * hostMaskData;
    float * deviceInputImageData;
    float * deviceOutputImageData;
    float * deviceMaskData;

    args = wbArg_read(argc, argv); /* parse the input arguments */

    inputImageFile = wbArg_getInputFile(args, 0);
    inputMaskFile = wbArg_getInputFile(args, 1);

    inputImage = wbImport(inputImageFile);
    hostMaskData = (float *) wbImport(inputMaskFile, &maskRows, &maskColumns);

    assert(maskRows == 5); /* mask height is fixed to 5 in this mp */
    assert(maskColumns == 5); /* mask width is fixed to 5 in this mp */

    imageWidth = wbImage_getWidth(inputImage);
    imageHeight = wbImage_getHeight(inputImage);
    imageChannels = wbImage_getChannels(inputImage);
    assert(imageChannels == 3);

    outputImage = wbImage_new(imageWidth, imageHeight, imageChannels);

    hostInputImageData = wbImage_getData(inputImage);
    hostOutputImageData = wbImage_getData(outputImage);

    wbTime_start(GPU, "Doing GPU Computation (memory + compute)");

    wbTime_start(GPU, "Doing GPU memory allocation");
    cudaMalloc((void **) &deviceInputImageData, imageWidth * imageHeight * imageChannels * sizeof(float));
    cudaMalloc((void **) &deviceOutputImageData, imageWidth * imageHeight * imageChannels * sizeof(float));
    cudaMalloc((void **) &deviceMaskData, maskRows * maskColumns * sizeof(float));
    wbTime_stop(GPU, "Doing GPU memory allocation");


    wbTime_start(Copy, "Copying data to the GPU");
    cudaMemcpy(deviceInputImageData,
               hostInputImageData,
               imageWidth * imageHeight * imageChannels * sizeof(float),
               cudaMemcpyHostToDevice);
    cudaMemcpy(deviceMaskData,
               hostMaskData,
               maskRows * maskColumns * sizeof(float),
               cudaMemcpyHostToDevice);
    wbTime_stop(Copy, "Copying data to the GPU");


    wbTime_start(Compute, "Doing the computation on the GPU");
    //@@ INSERT CODE HERE
    dim3 dimBlock(BLOCK_WIDTH, BLOCK_WIDTH);
    dim3 dimGrid((imageWidth - 1) / O_TILE_WIDTH + 1, (imageHeight - 1) / O_TILE_WIDTH + 1, 1);
    convolution_2D_kernel<<<dimGrid, dimBlock>>>(deviceOutputImageData, deviceInputImageData,
                                                 imageHeight, imageWidth, imageChannels, deviceMaskData);
    wbTime_stop(Compute, "Doing the computation on the GPU");


    wbTime_start(Copy, "Copying data from the GPU");
    cudaMemcpy(hostOutputImageData,
               deviceOutputImageData,
               imageWidth * imageHeight * imageChannels * sizeof(float),
               cudaMemcpyDeviceToHost);
    wbTime_stop(Copy, "Copying data from the GPU");

    wbTime_stop(GPU, "Doing GPU Computation (memory + compute)");

    wbSolution(args, outputImage);

    cudaFree(deviceInputImageData);
    cudaFree(deviceOutputImageData);
    cudaFree(deviceMaskData);

    free(hostMaskData);
    wbImage_delete(outputImage);
    wbImage_delete(inputImage);

    return 0;
}
