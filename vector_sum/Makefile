DIR = .
CXX = g++ -m64 
NVCC = nvcc -m64 --ptxas-options=-v 
CXXFLAGS = -std=c++11 -Wall 
LIBS = -lpthread -lcudart -lcublas -lcuda
LIBDIRS = -L/usr/local/cuda-9.0/lib64 
INCDIRS = -I/usr/local/cuda-9.0/include 
SRCDIR = $(DIR)/src
OBJDIR = $(DIR)/obj
OBJECTS = $(OBJDIR)/vector.o
EXE = vector

all: $(EXE)

$(EXE): $(OBJECTS)
	$(CXX) $(INCDIRS) -o $@  $^ $(LIBDIRS) $(LIBS) 

$(OBJDIR)/%.o: $(SRCDIR)/%.cu
	$(NVCC) -c  $< -o $@ 

.PHONY: clean

clean:
	@rm $(EXE) $(OBJDIR)/*
