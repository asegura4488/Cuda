#include <cuda.h>
#include <stdio.h>
#include <memory>
#include <iostream> 

const int Nthreads = 1024;
const int Nentries = 2048;
const int rows = 30;
const int columns = 30;
//const int blocksize = 16; 
 
__global__ 
void add_vectors(float *A, float *B, float *C, int N, int M, int L ) 
{
    int tx = threadIdx.x + blockDim.x*blockIdx.x;
	int ty = threadIdx.y + blockDim.y*blockIdx.y;
    float valor = 0.f;
    for (int i = 0; i<L; ++i){
    valor += A[ty*L+i]*B[i*M+tx];
    }
    C[ty*M+tx]=valor;			
}
 
int main()
{
        int N = rows;
        int M = columns;
        int L = 2;
        int *Nd, *Md, *Ld;
        float A[rows][columns], B[rows][columns], C[rows][columns];
        float *dev_a, *dev_b, *dev_c;

	cudaMalloc((void **) &dev_a, rows*columns*sizeof(int));
    cudaMalloc((void **) &dev_b, rows*columns*sizeof(int));
	cudaMalloc((void **) &dev_c, rows*columns*sizeof(int));
	cudaMalloc((void **) &Nd, N*sizeof(int));
	cudaMalloc((void **) &Md, M*sizeof(int));
	cudaMalloc((void **) &Ld, L*sizeof(int));

    cudaMemcpy( Nd, &N, N*sizeof(int), cudaMemcpyHostToDevice );
    cudaMemcpy( Md, &M, M*sizeof(int), cudaMemcpyHostToDevice );
    cudaMemcpy( Md, &L, M*sizeof(int), cudaMemcpyHostToDevice );
          
	// Fill Arrays
        for (int y = 0; y < rows; y++)
	for (int x = 0; x < columns; x++)
	{
	A[y][x] = 1.+float(x)+float(y);
	B[y][x] = 1.+float(y)+float(x+1);
	}
	

	cudaMemcpy( dev_a, &A, rows*columns*sizeof(int), cudaMemcpyHostToDevice ); 
	cudaMemcpy( dev_b, &B, rows*columns*sizeof(int), cudaMemcpyHostToDevice ); 


    dim3 dimGrid( Nentries/Nthreads+(Nentries % Nthreads ? 1 : 0), 2 );
    dim3 dimBlock( rows, columns );

 	add_vectors<<<dimGrid, dimBlock>>>(dev_a, dev_b, dev_c, N, M, L);
 	

        cudaMemcpy( &C, dev_c, rows*columns*sizeof(int), cudaMemcpyDeviceToHost ); 
	
 	cudaFree(dev_a);
        cudaFree(dev_b);
 	cudaFree(dev_c);
       
        for (int y = 0; y < rows; y++)
	for (int x = 0; x < columns; x++)
	{
	std::cout << "A["<<y<<"]["<<x<<"]= " << A[x][y] << " B["<<y<<"]["<<x<<"]= "  <<
        B[y][x] << " C["<<y<<"]["<<x<<"]= " << C[y][x]<< std::endl;
	}
        
	return EXIT_SUCCESS;
	//return 0;

	
}
