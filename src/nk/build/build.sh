
mkdir -p tmp

clang --target=wasm32 -c -Wall -std=c99 -fPIC -g -o tmp/nuklear-wasm.o nuklear.c
llvm-ar rc tmp/nuklear-wasm.a tmp/nuklear-wasm.o
cp tmp/nuklear-wasm.a ../lib/nuklear-wasm.o
