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
	char *a = (char *)malloc(input);
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
		wait(NULL);
		sleep(SLEEP);
		printf("M\n");
		fflush(stdout);
		sleep(SLEEP);
		exit(0);
	} else if(pid == 0) {
	//	getchar();
	printf("F\n");
	fflush(stdout);
	sleep(SLEEP);
	//fgets(c, 79, stdin);
	//scanf("%c",&c);
		a[TOMB] = 'b';
	printf("D\n");
	fflush(stdout);
	sleep(SLEEP);
	printf("W\n");
	fflush(stdout);
	sleep(SLEEP);
	//	getchar();
	//fgets(c, 79, stdin);
	//scanf("%c",&c);
		exit(0);
	}
	return 0;
}
