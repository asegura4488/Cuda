import numpy as np
from timeit import default_timer as timer

def VectorAdd(a, b, c):
	for i in range(a.size):
		c[i] = a[i] + b[i]
		#print(c[i],i)

def main():
	N = 50000000 #elements per Array

	A = np.ones(N, dtype=np.float32)
	B = np.ones(N, dtype=np.float32)
	C = np.zeros(N, dtype=np.float32)

	start = timer()
	VectorAdd(A, B, C)
	vector_time = timer() - start

	print("C[:10] = " + str(C[:10]))
	print("C[-10:] = " + str(C[-10:]))

	print("VectorAdd took %f seconds" % vector_time)


if __name__ == '__main__':
	main()

