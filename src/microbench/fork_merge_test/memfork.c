#include<stdlib.h>
#include<stdio.h>
#include <unistd.h>
#include<string.h>
#include<sys/wait.h>
#include<sys/types.h>

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
	posix_memalign(&a,(2*1024*1024),input);
	//char *a = (char *)malloc(input);
	//char *b = (char *)malloc(input);
	//char c[80];
	while (count < input) {
		a[count++] ='a';
	}
	printf("E\n");
	fflush(stdout);
	sleep(SLEEP);
	//fgets(c, 79, stdin);
	//scanf("%c",&c);
	pid = fork();
	if(pid > 0) {
		sleep(SLEEP*2);
		a[TOMB] = 'b';
		sleep(SLEEP*3);
		printf("W\n");
		fflush(stdout);
		sleep(SLEEP);
		wait(NULL);
		sleep(SLEEP*300);
		printf("M\n");
		fflush(stdout);
		sleep(SLEEP);
		exit(0);
	} else if(pid == 0) {
		printf("child pid %d\n", getpid());
		fflush(stdout);
		printf("F\n");
		fflush(stdout);
		sleep(SLEEP*20);
		exit(0);
	}
	return 0;
}
