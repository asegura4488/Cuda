#include <stdio.h>
#include <iostream> 

const int rows = 10;
const int columns = 20;
//const int blocksize = 16; 
 
__global__ 
void add_vectors(int *a, int *b, int *c) 
{
	int x = blockIdx.x;
	int y = blockIdx.y;
	int i = (columns*y) + x;
	c[i] = a[i] + b[i];
			
}
 
int main()
{
        int a[rows][columns], b[rows][columns], c[rows][columns];
        int *dev_a, *dev_b, *dev_c;

	cudaMalloc((void **) &dev_a, rows*columns*sizeof(int));
        cudaMalloc((void **) &dev_b, rows*columns*sizeof(int));
	cudaMalloc((void **) &dev_c, rows*columns*sizeof(int));
	
          
	// Fill Arrays
        for (int y = 0; y < rows; y++)
	for (int x = 0; x < columns; x++)
	{
	a[y][x] = x;
	b[y][x] = y;
	}
	

	cudaMemcpy( dev_a, &a, rows*columns*sizeof(int), cudaMemcpyHostToDevice ); 
	cudaMemcpy( dev_b, &b, rows*columns*sizeof(int), cudaMemcpyHostToDevice ); 
	
        dim3 grid(columns,rows);
        //dim3 dimBlock( N, 1 );
        //dim3 dimGrid( 1, 1 );
 	add_vectors<<<grid, 1>>>(dev_a, dev_b, dev_c);
 	

        cudaMemcpy( &c, dev_c, rows*columns*sizeof(int), cudaMemcpyDeviceToHost ); 
	
 	cudaFree(dev_a);
        cudaFree(dev_b);
 	cudaFree(dev_c);
       
        for (int y = 0; y < rows; y++)
	for (int x = 0; x < columns; x++)
	{
	std::cout << "y " << y << " x " << x << std::endl;
	std::cout << "a[y][x] " << a[y][x]  << " b[y][x] " << b[y][x] << " c[y][x] " << c[y][x]<< std::endl;
	}
        
	return EXIT_SUCCESS;
	//return 0;

	
}
