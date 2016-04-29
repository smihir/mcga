#include<stdlib.h>
#include<stdio.h>
#include <unistd.h>
#include<string.h>
#include<sys/wait.h>
#include<sys/types.h>
#include <sys/prctl.h>

#define INPUT2 1000
#define TOMB2 (2*1024*1024 + 1000)
#define TOMB (1000)
//#define TOMB (2*1024*1024 + 50)
//#define TOMB (3*1024*1024 - 500000)
#define SLEEP 1

void bdump(char *b, int len) {
    int i;
    printf("\n");
    printf("000000 ");
    for (i = 0 ; i < len; i++) {
        printf("%02x ", ((char*)b)[i]);
        //printf("%c ", ((char*)b)[i]);
        if (15 == i%16)
            printf("\n%06x ", (i + 1));
    }
    printf("\n");
}

	int
main(int argc, char* argv[])
{
	int input = atoi(argv[1]);
	int count = 0, pid = 0;
	char *a = NULL;
	int count2 = 0;
	prctl(47, 1, 0, 0, 0);
	posix_memalign((void **)&a,(2*1024*1024),input);
	printf("a is %lx\n", (unsigned long)a);
	//char *a = (char *)malloc(input);
	//char *b = (char *)malloc(input);
	//char c[80];
redo:
	count2++;
	while (count < input) {
		a[count++] ='a';
	}
	strncpy(a, "Hello World", 20);
	bdump(a, 100);
	printf("E\n");
	fflush(stdout);
	sleep(SLEEP);
	//fgets(c, 79, stdin);
	//scanf("%c",&c);
	pid = fork();
	if(pid > 0) {
		sleep(SLEEP*2);
		printf("D\n");
		fflush(stdout);
		sleep(SLEEP);
		a[TOMB2] = 'd';
		wait(NULL);
		bdump(a+990+2*1024*1024, 100);
		sleep(SLEEP*30);
		//a[TOMB2] = 'd';
		printf("M\n");
		fflush(stdout);
		//a[TOMB] = 'l';
		sleep(SLEEP);
		//printf("Will touch now\n");
		bdump(a + 2*1024*1024, 100);
		printf("Done 1\n");
		//bdump(a, 100);
		//printf("Done 2\n");
		if (count2 < 5)
			goto redo;
		exit(0);
	} else if(pid == 0) {
		printf("child pid %d\n", getpid());
		fflush(stdout);
		printf("C1\n");
		//a[TOMB] = 'b';
		bdump(a, 100);
		printf("F\n");
		fflush(stdout);
		sleep(SLEEP*10);	//sleep to allow parent to dirty page	
		exit(0);
	}
	return 0;
}
