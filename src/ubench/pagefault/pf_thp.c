#include <stdio.h>
#include <stdlib.h>

#define _2MB (2 * 1024 * 1024)
int main(int argc, char **argv) {
    int error, i;
    void *p = NULL;
    size_t alignment = _2MB;
    size_t size = _2MB;
    int nu_pages = 10;

    error = posix_memalign(&p, alignment, size);
    if (error != 0) {
        perror("posix memalign");
        exit(1);
    }

    // how much time does it take to handle this
    // page fault is what we want to profile
    ((char *)p)[0] = 'a';

    free(p);
    return 0;
}
