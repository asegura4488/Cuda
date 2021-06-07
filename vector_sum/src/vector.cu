#include <stdio.h>
#include <iostream> 

const int Nthreads = 1024;
const int Nentries = 2500;
 
__global__ 
void add_vectors(int *a, int *b, int *c) 
{

   // int tID = threadIdx.x;
    int tID = threadIdx.x + blockDim.x*blockIdx.x;  
	if (tID < Nentries){
	c[tID] = a[tID] + b[tID];
	}
}
 
int main()
{
        int a[Nentries], b[Nentries], c[Nentries]={0};
        int *dev_a, *dev_b, *dev_c;

	cudaMalloc((void **) &dev_a, Nentries*sizeof(int));
    cudaMemset(dev_a, 0, Nentries*sizeof(int));
    cudaMalloc((void **) &dev_b, Nentries*sizeof(int));
    cudaMemset(dev_b, 0, Nentries*sizeof(int));
	cudaMalloc((void **) &dev_c, Nentries*sizeof(int));
    cudaMemset(dev_c, 0, Nentries*sizeof(int));
	
	// Fill Arrays
	for (int i = 0; i < Nentries; i++)
	{
	a[i] = i;
	b[i] = i-1;
	}

	cudaMemcpy( dev_a, &a, Nentries*sizeof(int), cudaMemcpyHostToDevice ); 
	cudaMemcpy( dev_b, &b, Nentries*sizeof(int), cudaMemcpyHostToDevice ); 
	
    dim3 dimGrid( Nentries/Nthreads+(Nentries % Nthreads ? 1 : 0), 1 );
    dim3 dimBlock( Nthreads, 1 );

    add_vectors<<<dimGrid, dimBlock>>>(dev_a, dev_b, dev_c);
    cudaDeviceSynchronize(); 
    cudaMemcpy( &c, dev_c, Nentries*sizeof(int), cudaMemcpyDeviceToHost ); 
	
 	cudaFree(dev_a);
    cudaFree(dev_b);
 	cudaFree(dev_c);
       
        for (int i = 0; i < Nentries; i++)
	{
	std::cout << "a[i]=" << a[i] << " b[i]=" << b[i] << " c[i]=" << c[i] << std::endl; 
	}
	return EXIT_SUCCESS;
	//return 0;

	
}
