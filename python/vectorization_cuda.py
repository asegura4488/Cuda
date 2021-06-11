import numpy as np
import numba as numba
import GPUtil
import random
from timeit import default_timer as timer

from ROOT import TMath, TCanvas, TH1D

from numba import vectorize, cuda


pi=TMath.Pi()


@vectorize(['float32(float32, float32, float32)'], target='cuda')
#@vectorize(['float32(float32, float32)'], target='gpu')
def VectorAdd(a, b, pi):
	return a*b*pi

def Numba_init():

	if(numba.cuda.is_available() == False):
		print("GPU is not available")
		exit(1)

	numba.cuda.detect()
	gpus = cuda.gpus.lst
	for gpu in gpus:
		with gpu:
			meminfo = cuda.current_context().get_memory_info()
			print("%s, free: %s bytes, total, %s bytes" % (gpu, meminfo[0], meminfo[1]))


def main():

	Numba_init()
	N = 50000000 #elements per Array

	A = np.ones(N, dtype=np.float32)
	B = np.ones(N, dtype=np.float32)

	"""
	for i in range(len(A)):
		A[i] = np.random.poisson()
	"""

	start = timer()
	C=VectorAdd(A, B, pi)
	GPUtil.showUtilization()
	vector_time = timer() - start

	print("C[:10] = " + str(C[:10]))
	print("C[-10:] = " + str(C[-10:]))

	print("VectorAdd took %f seconds" % vector_time)

	h1 = TH1D("h1", "test", 100, 0, 100)
	h1.Sumw2()

	for i in range(0,1000):
		h1.Fill(C[i])
	h1.Draw()
	input()

if __name__ == '__main__':
	main()

