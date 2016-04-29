#include <stdio.h>
#include <stdlib.h>

#define _2MB (2 * 1024 * 1024)
int main(int argc, char **argv) {
    int error, i;
    void *p = NULL;
    size_t alignment = _2MB;
    size_t size = _2MB;
    int pid, status;

    error = posix_memalign(&p, alignment, size);
    if (error != 0) {
        perror("posix memalign");
        exit(1);
    }

    // how much time does it take to handle this
    // page fault is what we want to profile
    ((char *)p)[0] = 'a';

    pid = fork();
    if (pid < 0) {
        printf("fork error\n");
        exit(1);
    } else if (pid == 0) {
        // in child, wait for a couple of seconds
        // for parent to trigger a CoW fault
        sleep(2);
    } else {
        // in parent, trigger a CoW fault on a
        // huge page
        ((char *)p)[0] = 'b';
        wait(&status);
    }

    free(p);
    return 0;
}
