#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

#define _2MB (2 * 1024 * 1024)
#define MAX_SIZE (4 * 1024)
int main(int argc, char **argv) {
    int error, i;
    void *p[MAX_SIZE] = {NULL};
    size_t page_size = sysconf(_SC_PAGESIZE);

    for (i = 0; i < MAX_SIZE; i++) {
        p[i] = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
                    MAP_SHARED | MAP_ANONYMOUS, -1, 0);
        if (p == MAP_FAILED) {
            printf("mmap failed\n");
            exit(1);
        }
    }

    // how much time does it take to handle this
    // page fault is what we want to profile
    for (i = 0; i < MAX_SIZE; i++) {
        ((char *)p[i])[0] = 'a';
    }

    return 0;
}
