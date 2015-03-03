#include    <wb.h>

__global__ void vecAdd(float * in1, float * in2, float * out, int len) {
    //@@ Insert code to implement vector addition here
    int tx = threadIdx.x + blockDim.x * blockIdx.x;
    if (tx < len) out[tx] = in1[tx] + in2[tx];
    return;
}

int main(int argc, char ** argv) {
    wbArg_t args;
    int inputLength;
    float * hostInput1;
    float * hostInput2;
    float * hostOutput;
    float * d11, *d21;
    float * d12, *d22;
    float * dout1, *dout2;

    args = wbArg_read(argc, argv);

    wbTime_start(Generic, "Importing data and creating memory on host");
    hostInput1 = (float *) wbImport(wbArg_getInputFile(args, 0), &inputLength);
    hostInput2 = (float *) wbImport(wbArg_getInputFile(args, 1), &inputLength);
    hostOutput = (float *) malloc(inputLength * sizeof(float));
    wbTime_stop(Generic, "Importing data and creating memory on host");

    const int segsize = 4096;
    cudaMalloc((void **)&d11, segsize * sizeof(float));
    cudaMalloc((void **)&d12, segsize * sizeof(float));
    cudaMalloc((void **)&dout1, segsize * sizeof(float));
    cudaMalloc((void **)&d21, segsize * sizeof(float));
    cudaMalloc((void **)&d22, segsize * sizeof(float));
    cudaMalloc((void **)&dout2, segsize * sizeof(float));
    
    cudaStream_t s1, s2, s3, s4;
    cudaStreamCreate(&s1);
    cudaStreamCreate(&s2);
    cudaStreamCreate(&s3);
    cudaStreamCreate(&s4);

    // use one stream currently
    int number[2];
    for (int i = 0; i < inputLength; i += 2 * segsize) {
        // handle boundary conditions in case (inputLength % segsize != 0)
        for (int j = 0; j < 2; ++j) {
            if (i + j * segsize + segsize <= inputLength) number[j] = segsize;
            else if (i + j * segsize < inputLength) number[j] = inputLength - i - j * segsize;
            else number[j] = 0;
        }
        cudaMemcpyAsync(d11, hostInput1 + i, number[0] * sizeof(float), cudaMemcpyHostToDevice, s1);
        cudaMemcpyAsync(d12, hostInput2 + i, number[0] * sizeof(float), cudaMemcpyHostToDevice, s1);
        cudaMemcpyAsync(d21, hostInput1 + i + segsize * 1, number[1] * sizeof(float), cudaMemcpyHostToDevice, s2);
        cudaMemcpyAsync(d22, hostInput2 + i + segsize * 1, number[1] * sizeof(float), cudaMemcpyHostToDevice, s2);
        vecAdd<<<(number[0] - 1) / 256 + 1, 256, 0, s1>>>(d11, d12, dout1, number[0]);
        cudaMemcpyAsync(hostOutput + i, dout1, number[0] * sizeof(float), cudaMemcpyDeviceToHost, s1);
        vecAdd<<<(number[1] - 1) / 256 + 1, 256, 0, s2>>>(d21, d22, dout2, number[1]);
        cudaMemcpyAsync(hostOutput + i + segsize * 1, dout2, number[1] * sizeof(float), cudaMemcpyDeviceToHost, s2);
    }

    cudaFree(d11); cudaFree(d21);
    cudaFree(d12); cudaFree(d22);
    cudaFree(dout1); cudaFree(dout2);

    wbSolution(args, hostOutput, inputLength);

    free(hostInput1);
    free(hostInput2);
    free(hostOutput);

    return 0;
}

