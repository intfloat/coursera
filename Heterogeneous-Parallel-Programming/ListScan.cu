// MP 5 Scan
// Given a list (lst) of length n
// Output its prefix sum = {lst[0], lst[0] + lst[1], lst[0] + lst[1] + ... + lst[n-1]}

// Declaration: I am not the author of this source code,
//              just borrowed it from some guy and study it.

#include    <wb.h>

#define BLOCK_SIZE 512 //@@ You can change this
#define SECTION_SIZE BLOCK_SIZE

#define wbCheck(stmt) do {                                 \
        cudaError_t err = stmt;                            \
        if (err != cudaSuccess) {                          \
            wbLog(ERROR, "Failed to run stmt ", #stmt);    \
            return -1;                                     \
        }                                                  \
    } while(0)


__global__ void adjust(float* output, float* sums, int len) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < len && blockIdx.x > 0)
        output[i] += sums[blockIdx.x - 1];
    return;
}

__global__ void scan(float * input, float * output, float* sums, int len) {
    //@@ Modify the body of this function to complete the functionality of
    //@@ the scan on the device
    //@@ You may need multiple kernel calls; write your kernels before this
    //@@ function and call them from here
    __shared__ float xy[SECTION_SIZE];
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < len)
        xy[threadIdx.x] = input[i];

    for (unsigned int stride = 1; stride <= threadIdx.x; stride *= 2) {
        __syncthreads();
        float in1 = 0.0;
        if (threadIdx.x >= stride)
            in1 = xy[threadIdx.x - stride];
        __syncthreads();
        xy[threadIdx.x] += in1;
    }

    __syncthreads();

    if (i < len) output[i] = xy[threadIdx.x];

    if (sums != NULL && threadIdx.x == blockDim.x - 1)
        sums[blockIdx.x] = output[i];
    return;
}

int main(int argc, char ** argv) {
    wbArg_t args;
    float * hostInput; // The input 1D list
    float * hostOutput; // The output list
    float * deviceInput;
    float * deviceOutput;
    float * deviceSums;
    float * deviceSums2;
    int numElements; // number of elements in the list

    args = wbArg_read(argc, argv);

    wbTime_start(Generic, "Importing data and creating memory on host");
    hostInput = (float *) wbImport(wbArg_getInputFile(args, 0), &numElements);
    hostOutput = (float*) malloc(numElements * sizeof(float));
    wbTime_stop(Generic, "Importing data and creating memory on host");

    wbLog(TRACE, "The number of input elements in the input is ", numElements);

    wbTime_start(GPU, "Allocating GPU memory.");
    wbCheck(cudaMalloc((void**)&deviceInput, numElements*sizeof(float)));
    wbCheck(cudaMalloc((void**)&deviceOutput, numElements*sizeof(float)));
    wbCheck(cudaMalloc((void**)&deviceSums, (numElements/BLOCK_SIZE + 1) * sizeof(float)));
    wbCheck(cudaMalloc((void**)&deviceSums2, (numElements/BLOCK_SIZE + 1) * sizeof(float)));
    wbTime_stop(GPU, "Allocating GPU memory.");

    wbTime_start(GPU, "Clearing output memory.");
    wbCheck(cudaMemset(deviceOutput, 0, numElements*sizeof(float)));
    wbTime_stop(GPU, "Clearing output memory.");

    wbTime_start(GPU, "Copying input memory to the GPU.");
    wbCheck(cudaMemcpy(deviceInput, hostInput, numElements*sizeof(float), cudaMemcpyHostToDevice));
    wbTime_stop(GPU, "Copying input memory to the GPU.");

    //@@ Initialize the grid and block dimensions here
    int numBlocks = (numElements - 1) / BLOCK_SIZE + 1;

    wbTime_start(Compute, "Performing CUDA computation");
    //@@ Modify this to complete the functionality of the scan
    //@@ on the deivce
    dim3 dimGrid1(numBlocks, 1, 1);
    dim3 dimBlock1(BLOCK_SIZE, 1, 1);
    scan<<<dimGrid1, dimBlock1>>>(deviceInput, deviceOutput, deviceSums, numElements);
    wbCheck(cudaDeviceSynchronize());

    dim3 dimGrid2(1, 1, 1);
    dim3 dimBlock2(numBlocks, 1, 1);
    scan<<<dimGrid2, dimBlock2>>>(deviceSums, deviceSums2, NULL, numBlocks);
    wbCheck(cudaDeviceSynchronize());


    dim3 dimGrid3(numBlocks, 1, 1);
    dim3 dimBlock3(BLOCK_SIZE, 1, 1);
    adjust<<<dimGrid3, dimBlock3>>>(deviceOutput, deviceSums2, numElements);
    wbCheck(cudaDeviceSynchronize());

    wbTime_stop(Compute, "Performing CUDA computation");

    wbTime_start(Copy, "Copying output memory to the CPU");
    wbCheck(cudaMemcpy(hostOutput, deviceOutput, numElements*sizeof(float), cudaMemcpyDeviceToHost));
    wbTime_stop(Copy, "Copying output memory to the CPU");

    wbTime_start(GPU, "Freeing GPU Memory");
    wbCheck(cudaFree(deviceInput));
    wbCheck(cudaFree(deviceOutput));
    wbCheck(cudaFree(deviceSums));
    wbCheck(cudaFree(deviceSums2));
    wbTime_stop(GPU, "Freeing GPU Memory");

    wbSolution(args, hostOutput, numElements);

    free(hostInput);
    free(hostOutput);

    return 0;
}
