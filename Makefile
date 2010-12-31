CXX = g++
CXXFLAGS = -g -Wall

COMMON = \
	out/module.o \
	out/data.o \
	out/bytecode.o \
	out/object.o \
	out/numeric.o \
	out/code.o \
	out/sequence.o \
	out/string.o \
	out/ASTree.o \
	out/ASTNode.o \

BYTES = \
	out/python_10.o \
	out/python_11.o \
	out/python_13.o \
	out/python_14.o \
	out/python_15.o \
	out/python_16.o \
	out/python_20.o \
	out/python_21.o \
	out/python_22.o \
	out/python_23.o \
	out/python_24.o \
	out/python_25.o \
	out/python_26.o \
	out/python_27.o \
	out/python_30.o \
	out/python_31.o

ALL = \
	bin/pycdas \
	bin/pycdc

PREFIX = /usr/local

all: $(ALL)

clean:
	rm -f $(COMMON) $(BYTES)

install:
	mkdir -p $(PREFIX)/bin
	cp $(ALL) $(PREFIX)/bin

test: all
	@for f in ./tests/*; \
	do \
		./bin/pycdc "$$f" > /dev/null; \
		if [ "$$?" -eq "0" ]; then \
			echo "\033[32mPASSED\033[m $$f"; \
		else \
			echo "\033[31mFAILED\033[m $$f"; \
		fi \
	done;

bin/pycdas: pycdas.cpp $(COMMON) $(BYTES)
	$(CXX) $(CXXFLAGS) $(COMMON) $(BYTES) pycdas.cpp -o $@

bin/pycdc: pycdc.cpp $(COMMON) $(BYTES)
	$(CXX) $(CXXFLAGS) $(COMMON) $(BYTES) pycdc.cpp -o $@

out/module.o: module.h module.cpp
	$(CXX) $(CXXFLAGS) -c module.cpp -o $@

out/data.o: data.h data.cpp
	$(CXX) $(CXXFLAGS) -c data.cpp -o $@

out/bytecode.o: bytecode.h bytecode.cpp
	$(CXX) $(CXXFLAGS) -c bytecode.cpp -o $@

out/object.o: object.h object.cpp
	$(CXX) $(CXXFLAGS) -c object.cpp -o $@

out/numeric.o: numeric.h numeric.cpp
	$(CXX) $(CXXFLAGS) -c numeric.cpp -o $@

out/code.o: code.h code.cpp
	$(CXX) $(CXXFLAGS) -c code.cpp -o $@

out/sequence.o: sequence.h sequence.cpp
	$(CXX) $(CXXFLAGS) -c sequence.cpp -o $@

out/string.o: string.h string.cpp
	$(CXX) $(CXXFLAGS) -c string.cpp -o $@

out/ASTree.o: ASTree.h ASTree.cpp
	$(CXX) $(CXXFLAGS) -c ASTree.cpp -o $@

out/ASTNode.o: ASTNode.h ASTNode.cpp
	$(CXX) $(CXXFLAGS) -c ASTNode.cpp -o $@

out/python_%.o: bytes/python_%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

bytes/python_%.cpp: bytes/python_%.map
	( cd bytes ; ./comp_map.py )
