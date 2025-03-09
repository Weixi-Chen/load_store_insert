# load_store_insert

- LLVM Pass: llvm_insert.cpp
- Test File: test.c
- Final Executable after compiling test.c: instrumented_program

# Process execute this program in Docker

## Step 1: Build the Docker Image (using the Dockerfile)
```sh
docker build -t llvm-env .
```
## Step 2: Run the Docker Image
```sh
docker run -it -v $(pwd):/app llvm-env
```
## Step 3: Compile llvm_insert.cpp (LLVM Pass) with Clang
```sh
clang++ -fPIC -shared -o InstrumentLoadStore.so llvm_insert.cpp $(llvm-config --cxxflags --ldflags --system-libs --libs core)
```
Compiles llvm_insert.cpp -> InstrumentLoadStore.so (LLVM Pass Library)

## Step 4: Generate LLVM IR (with optone disabled, allowing optimization passes)
``` sh
clang -Xclang -disable-O0-optnone -S -emit-llvm test.c -o test.ll
```
Compiles test.c -> test.ll

## Step 5: Apply LLVM Pass to test.ll
``` sh
opt -load-pass-plugin=./InstrumentLoadStore.so -passes=instrument-load-store -S test.ll -o instrumented.ll
```
using LLVM's optimization tool opt to apply pass on test.ll -> instrumented.ll

## Step 6: Generate Assembly Code from LLVM IR
``` sh
llc instrumented.ll -o instrumented.s
```
instrumented.ll -> instrumented.s (assembly file)

## Step 7: Compile Assembly code to Executable file using Clang
``` sh
clang instrumented.s -o instrumented_program -lm
```
instrumented.s -> instrumented_program (executable)

## Step 8: Run the program!
``` sh
./instrumented_program
```
