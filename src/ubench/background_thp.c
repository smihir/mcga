#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

#define _4KB (4 * 1024)
#define _2MB (2 * 1024 * 1024)
#define MAX_SIZE (256 * 1024) // 256KB
#define ARR_SIZE (16)
int main(int argc, char **argv) {
    int error, i,j;
    void *p[ARR_SIZE] = {NULL};
    size_t page_size = sysconf(_SC_PAGESIZE);

    for (i = 0; i < ARR_SIZE; i++) {
        p[i] = mmap(NULL, MAX_SIZE, PROT_READ | PROT_WRITE,
                    MAP_SHARED | MAP_ANONYMOUS, -1, 0);
        if (p == MAP_FAILED) {
            printf("mmap failed\n");
            exit(1);
        }
    }

    // how much time does it take to handle this
    // page fault is what we want to profile
    for (i = 0; i < ARR_SIZE; i++) {
        for (j = 0; j < MAX_SIZE; j += _4KB) {
            ((char *)p[i])[j] = 'a';
        }
    }

    return 0;
}
