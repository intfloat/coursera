#include <wb.h> //@@ wb include opencl.h for you

//@@ OpenCL Kernel
const char* vaddsrc = "__kernel void vecadd(__global float* A,            \n \
                                         __global float* B,            \n \
                                         __global float* C,            \n \
                                         int len) {                    \n \
                                  int id = get_global_id(0);           \n \
                                  if (id < len) C[id] = A[id] + B[id]; \n \
                                  return;                              \n \
                                }                                      \n";

int main(int argc, char **argv) {
  wbArg_t args;
  int inputLength;
  float *hostInput1;
  float *hostInput2;
  float *hostOutput;
  float *deviceInput1;
  float *deviceInput2;
  float *deviceOutput;

  args = wbArg_read(argc, argv);

  wbTime_start(Generic, "Importing data and creating memory on host");
  hostInput1 = ( float * )wbImport(wbArg_getInputFile(args, 0), &inputLength);
  hostInput2 = ( float * )wbImport(wbArg_getInputFile(args, 1), &inputLength);
  hostOutput = ( float * )malloc(inputLength * sizeof(float));
  wbTime_stop(Generic, "Importing data and creating memory on host");

  wbLog(TRACE, "The input length is ", inputLength);

  wbTime_start(GPU, "Allocating GPU memory.");
  //@@ Allocate GPU memory here
  cl_int clerr = CL_SUCCESS;
  cl_platform_id cpPlatform;        // OpenCL platform
  cl_device_id device_id;           // device ID
    
  // Bind to platform
  clerr = clGetPlatformIDs(1, &cpPlatform, NULL); 
  // Get ID for the device
  clerr = clGetDeviceIDs(cpPlatform, CL_DEVICE_TYPE_GPU, 1, &device_id, NULL); 
  // Create a context  
  cl_context clctx = clCreateContext(0, 1, &device_id, NULL, NULL, &clerr); 
  // Create a command queue 
  cl_command_queue clcmdq = clCreateCommandQueue(clctx, device_id, 0, &clerr);

  int size = inputLength * sizeof(float);
  cl_mem d_a = clCreateBuffer(clctx, CL_MEM_READ_ONLY, size, NULL, NULL);
  cl_mem d_b = clCreateBuffer(clctx, CL_MEM_READ_ONLY, size, NULL, NULL);
  cl_mem d_c = clCreateBuffer(clctx, CL_MEM_WRITE_ONLY, size, NULL, NULL);  
  cl_program clpgm = clCreateProgramWithSource(clctx, 1, &vaddsrc, NULL, &clerr);
  clerr = clBuildProgram(clpgm, 0, NULL, NULL, NULL, NULL);
  cl_kernel clkern = clCreateKernel(clpgm, "vecadd", &clerr); 

  wbTime_stop(GPU, "Allocating GPU memory.");

  wbTime_start(GPU, "Copying input memory to the GPU.");
  //@@ Copy memory to the GPU here
  clerr = clEnqueueWriteBuffer(clcmdq, d_a, CL_TRUE, 0, size, hostInput1, 0, NULL, NULL);
  clerr |= clEnqueueWriteBuffer(clcmdq, d_b, CL_TRUE, 0, size, hostInput2, 0, NULL, NULL);

  wbTime_stop(GPU, "Copying input memory to the GPU.");

  //@@ Initialize the grid and block dimensions here
  size_t localSize = 64;
  size_t globalSize = (inputLength - 1) / localSize + 1;
  globalSize *= localSize;

  wbTime_start(Compute, "Performing CUDA computation");
  //@@ Launch the GPU Kernel here
  clerr |= clSetKernelArg(clkern, 0, sizeof(cl_mem), (void *)&d_a);
  clerr |= clSetKernelArg(clkern, 1, sizeof(cl_mem), (void *)&d_b);
  clerr |= clSetKernelArg(clkern, 2, sizeof(cl_mem), (void *)&d_c);
  clerr |= clSetKernelArg(clkern, 3, sizeof(int), &inputLength);

  cl_event event = NULL;
  // clerr |= clEnqueueNDRangeKernel(clcmdq, clkern, 2, NULL, &globalSize, &localSize, 0, NULL, &event);
  clerr |= clEnqueueNDRangeKernel(clcmdq, clkern, 1, NULL, &globalSize, &localSize, 0, NULL, NULL);
  // clWaitForEvents(1, &event);
  clFinish(clcmdq);

  // cudaDeviceSynchronize();
  wbTime_stop(Compute, "Performing CUDA computation");

  wbTime_start(Copy, "Copying output memory to the CPU");
  //@@ Copy the GPU memory back to the CPU here
  clEnqueueReadBuffer(clcmdq, d_c, CL_TRUE, 0, size, hostOutput, 0, NULL, NULL);
  clFinish(clcmdq);

  wbTime_stop(Copy, "Copying output memory to the CPU");

  wbTime_start(GPU, "Freeing GPU Memory");
  //@@ Free the GPU memory here
  clReleaseMemObject(d_a);
  clReleaseMemObject(d_b);
  clReleaseMemObject(d_c);
  // clReleaseProgram(clpgm);
  // clReleaseKernel(clkern);
  // clReleaseCommandQueue(clcmdq);
  // clReleaseContext(clctx);

  wbTime_stop(GPU, "Freeing GPU Memory");

  wbSolution(args, hostOutput, inputLength);

  free(hostInput1);
  free(hostInput2);
  free(hostOutput);

  return 0;
}
