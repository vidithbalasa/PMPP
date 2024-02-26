#include <iostream>
#include <vector>
#include <numeric>

__global__ void vecAddKernel(int* a, int* b, int* c, int n) {
    int x = blockDim.x * blockIdx.x + threadIdx.x;
    if (x < n) {
        c[x] = a[x] + b[x];
    }
}

int main() {
    int n = 100000000;
    int size = n * sizeof(int);
    std::vector<int> a(n);
    std::vector<int> b(n);
    std::vector<int> c(n);
    // int c[n];

    std::iota(a.begin(), a.end(), 0);
    std::iota(b.begin(), b.end(), 0);

    int *d_A, *d_B, *d_C;

    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);

    cudaMemcpy(d_A, a.data(), size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, b.data(), size, cudaMemcpyHostToDevice);

    vecAddKernel<<<(size + 256 - 1 / 256.0), 256>>>(d_A, d_B, d_C, n);

    cudaMemcpy(c.data(), d_C, size, cudaMemcpyDeviceToHost);

    /*
    for (int i=0; i<n; i++) {
        std::cout << c[i] << " ";
    }
    std::cout << std::endl;
    */
    
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}
