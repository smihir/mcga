#include<stdio.h>

void test1(int i,char a);

int main(){

    int i=10;
    test1(10,'a');
    return 0;
}

void test1(int i, char a){
    int j,k;
    for(j=0;j<100;j++){
        for(k=0;k<100;k++){
            i=(i+1)%453453;
            //sleep(1);
        }
    }       
    printf("new\n");
}    
