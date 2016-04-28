#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/time.h>

#define _2MB (2 * 1024 * 1024)

size_t zmalloc_get_smap_bytes_by_field(char *field) {
    char line[1024];
    size_t bytes = 0;
    FILE *fp = fopen("/proc/self/smaps","r");
    int flen = strlen(field);

    if (!fp) return 0;
    while(fgets(line,sizeof(line),fp) != NULL) {
        if (strncmp(line,field,flen) == 0) {
            char *p = strchr(line,'k');
            if (p) {
                *p = '\0';
                bytes += strtol(line+flen,NULL,10) * 1024;
            }
        }
    }
    fclose(fp);
    return bytes;
}

// Time counters
long long unsigned int get_gettimeofday(struct timeval tv1, struct timeval tv2) {
	long long unsigned int elapsed_msec;
    elapsed_msec = (tv2.tv_sec - tv1.tv_sec) * 1000 * 1000;
    elapsed_msec += (tv2.tv_usec - tv1.tv_usec);
    return elapsed_msec;
}

int main(int argc, char **argv) {
	char *a;
	unsigned int mb, count, i;
	int pid;
	struct timeval tv1, tv2;
	size_t rss, vmsize, thpsize;

	if (argc == 0) {
		printf("provide the RSS Size in MB\n");
		exit(1);
	}
	mb = strtoul(argv[1], NULL, 10);
	count = mb / 2;
	for (i = 0; i < count; i++) {
		unsigned int j;
		posix_memalign((void **)&a, _2MB, _2MB);
		for (j = 0; j < _2MB; j++)
			a[j] = 'a';
	}
	
	rss = zmalloc_get_smap_bytes_by_field("Rss:");
	vmsize = zmalloc_get_smap_bytes_by_field("Size:");
	thpsize = zmalloc_get_smap_bytes_by_field("AnonHugePages:");

	gettimeofday(&tv1, NULL);
	// get the start time
	pid = fork();

	if (pid > 0) {
		// in parent. get the end time and calculate delta
		gettimeofday(&tv2, NULL);	
		wait(NULL);

	} else if (pid == 0) {
		// in child, just exit
		exit(0);
	} else {
		printf("fork failed!\n");
		exit(1);
	}

	printf("VMSIZE: %zu RSS: %zu, Time: %llu us\n", vmsize, rss, get_gettimeofday(tv1, tv2));
	printf("mb = %u, count = %u thpsize = %zu\n", mb, count, thpsize);
	return 0;
}
