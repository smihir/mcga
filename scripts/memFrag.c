#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
int main () { 
    int input = ( 3 * 1024 * 1024 );    
    int i;
    int count = 0;
    char *a; 
    for ( i = 0; ; i++ ) { 
        count = 0;
        posix_memalign((void **)&a,(2*1024*1024),input);
        while ( count < input ) {
            a[count++] = 'a';
        }
        if ( (i % 1000)  == 0 ) { printf("%d\n", i); }
        if ( i > 14500 ) {
            if ( (i % 100)  == 0 ) {  
                usleep ( 1000 * 100  );
            }
            free(a);
        }
    }
    return 0;
}

