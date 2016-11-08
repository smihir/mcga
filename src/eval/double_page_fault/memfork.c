#include<stdlib.h>
#include<stdio.h>
#include <unistd.h>
#include<string.h>
#include<sys/wait.h>
#include<sys/types.h>
#include <sys/prctl.h>

#define INPUT2 1000
#define TOMB (2*1024*1024 - 1000)
//#define TOMB (2*1024*1024 + 50)
//#define TOMB (3*1024*1024 - 500000)
#define SLEEP 1
	int
main(int argc, char* argv[])
{
	int input = atoi(argv[1]);
	int count = 0, pid = 0;
	char *a = NULL;
	prctl(47, 1, 0, 0, 0);
	posix_memalign((void **)&a,(2*1024*1024),input);
	//char *a = (char *)malloc(input);
	//char *b = (char *)malloc(input);
	//char c[80];
	while (count < input) {
		a[count++] ='a';
	}
	printf("address is %p\n",&a[TOMB]);
	printf("E\n");
	fflush(stdout);
	sleep(SLEEP);
	pid = fork();
	if(pid > 0) {
		sleep(SLEEP);
		a[TOMB] = 'b';
		sleep(SLEEP);
		printf("D\n");
		fflush(stdout);
		sleep(SLEEP);
		wait(NULL);
		sleep(SLEEP*30);
		printf("M\n");
		fflush(stdout);
		sleep(SLEEP);
	} else if(pid == 0) {
		printf("child pid %d\n", getpid());
		fflush(stdout);
		printf("F\n");
		fflush(stdout);
		sleep(SLEEP*5);	//sleep to allow parent to dirty page	
		exit(0);
	}
	count = 0;
	while (count < input) {
		a[count++] ='a';
	}


	printf("E\n");
	fflush(stdout);
	sleep(SLEEP);
	pid = fork();
	if(pid > 0) {
		sleep(SLEEP);
		a[TOMB] = 'b';
		sleep(SLEEP);
		printf("D\n");
		fflush(stdout);
		sleep(SLEEP);
		wait(NULL);
		sleep(SLEEP*30);
		printf("M\n");
		fflush(stdout);
		sleep(SLEEP);
		exit(0);
	} else if(pid == 0) {
		printf("child pid %d\n", getpid());
		fflush(stdout);
		printf("F\n");
		fflush(stdout);
		sleep(SLEEP*5);	//sleep to allow parent to dirty page	
		exit(0);
	}
	return 0;
}
