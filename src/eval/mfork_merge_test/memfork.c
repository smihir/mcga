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
    int i;
    prctl(47, 1, 2, 0, 0);
    posix_memalign((void **)&a,(2*1024*1024),input);
    while (count < input) {
        a[count++] ='a';
    }
    printf("E\n");
    //printf("Dirtying 0x%08x base 0x%08x %p\n", a+TOMB, a, a);
    fflush(stdout);
    sleep(SLEEP * 2 );
    for ( i = 0; i < 2; i ++ ) {
        pid = fork();
        if(pid > 0) {
            if ( i == 0 ) continue;	
            sleep(SLEEP*2);
            printf("Par: Dir: %p Base: %p\n", a+TOMB, a);
            fflush(stdout);
            scanf("%d", &i);
            a[TOMB] = 'b';
            scanf("%d", &i);
            sleep(SLEEP*3);
            printf("D\n");
            fflush(stdout);
            sleep(SLEEP);
            wait(NULL);
            sleep(SLEEP*10);
            printf("M\n");
            fflush(stdout);
            sleep(SLEEP);
            exit(0);
        } else if(pid == 0) {
            printf("child pid %d\n", getpid());
            fflush(stdout);
            if ( i == 0 ) sleep(SLEEP*3);	//sleep to allow parent to dirty page	
            printf("F\n");
            fflush(stdout);
            sleep(SLEEP*1000);	//sleep to allow parent to dirty page	
            exit(0);
        }
    }
    return 0;
}
