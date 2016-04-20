#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>

int main()
{
    int error;
    void *p;
    unsigned long  alignment = 4096 * 512;
    size_t size;

	error = posix_memalign(&p, alignment, alignment * 2);
	if (error != 0) {
	    perror("posix_memalign");
	    exit(EXIT_FAILURE);
	}
	((char *)p)[0] = 'a';
	printf("posix_memalign(%d, %lu) = %p\n", alignment, size, p);
	sleep(60);
    return 0;
}
