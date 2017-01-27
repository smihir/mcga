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
	char c[80];
	while (count < input) {
		a[count++] ='a';
	}
	printf("Before Fork pid %d\n", getpid());
	fflush(stdout);
    scanf("%s", c);
	//fgets(c, 79, stdin);
	printf("%s\n",c);
	fflush(stdout);
	pid = fork();
	if(pid > 0) {
		printf("Parent after fork child pid %d\n", pid);
		fflush(stdout);
        scanf("%s", c);
		//fgets(c, 79, stdin);
		printf("%s\n",c);
		fflush(stdout);
		a[TOMB] = 'b';
		printf("Parent after dirty\n");
		fflush(stdout);
        scanf("%s", c);
		//fgets(c, 79, stdin);
		printf("%s\n",c);
		fflush(stdout);
		wait(NULL);
		exit(0);
	} else if(pid == 0) {
		sleep(30);
		printf("Child after fork pid %d\n", getpid());
		fflush(stdout);
        scanf("%s", c);
		//fgets(c, 79, stdin);
		printf("%s\n",c);
		fflush(stdout);
		exit(0);
	}
	return 0;
}
