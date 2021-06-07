DIR = .
CXX = g++ -m64
NVCC = nvcc -m64
CXXFLAGS = -std=c++11 -Wall 
LIBS = -lpthread -lcudart -lcublas -lcuda
LIBDIRS = -L/usr/local/cuda-10.0/lib64 
INCDIRS = -I/usr/local/cuda-10.0/include 
SRCDIR = $(DIR)/src
OBJDIR = $(DIR)/obj
OBJECTS = $(OBJDIR)/matrix.o
EXE = matrix

all: $(EXE)

$(EXE): $(OBJECTS)
	$(CXX) $(INCDIRS) -o $@  $^ $(LIBDIRS) $(LIBS) 

$(OBJDIR)/%.o: $(SRCDIR)/%.cu
	$(NVCC) -c  $< -o $@ 

.PHONY: clean

clean:
	@rm $(EXE) $(OBJDIR)/*
