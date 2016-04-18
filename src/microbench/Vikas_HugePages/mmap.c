/*
 * 1.c
 *
 *  Created on: Jan 29, 2016
 *      Author: vikasgoel
 */

#define _GNU_SOURCE
#include<sched.h>

#include<arpa/inet.h>
#include<assert.h>
#include<errno.h>
#include<fcntl.h>
#include<limits.h>
#include<math.h>
#include<netdb.h>
#include<netinet/in.h>
#include<netinet/tcp.h>
#include<pthread.h>
#include<stdbool.h>
#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<sys/mman.h>
#include<sys/socket.h>
#include<sys/stat.h>
#include<sys/time.h>
#include<sys/types.h>
#include<sys/wait.h>
#include<unistd.h>

#define MAX_BUFF (512*1024)
#define NUM_MSG 11
#define MSG_SIZE (MAX_BUFF/128)
#define ENABLE_SET_SOCKET (0)
#define NO_WARMUP 0
#define PARENT_PROCESSOR 0
#define CHILD_PROCESSOR 1

int opt = 1;

void time_shmem_latency();


char get(int *count);
void put(char value, int *count);

// Time counters
struct timeval tv1, tv2;		// gettimeofday
struct timespec ts1,ts2;		// clock_gettime
unsigned long long start,end;	// rdtsc

int freq;

// Clock associate functions
// Wall clock
long long unsigned int get_gettimeofday(){
	long long unsigned int elapsed_msec;
    elapsed_msec = (tv2.tv_sec - tv1.tv_sec) * 1000 * 1000;
    elapsed_msec += (tv2.tv_usec - tv1.tv_usec);
    return elapsed_msec;
}

// CPU time
long long unsigned int get_clock_gettime(){
	long long unsigned int elapsed_msec;
    elapsed_msec = (ts2.tv_sec - ts1.tv_sec) * 1000 * 1000 ;
    elapsed_msec += (ts2.tv_nsec - ts1.tv_nsec) / 1000;
    return elapsed_msec;
}

// CPU time
unsigned long long get_rdtsc(){
	return (end-start)/freq;
}

int fill;
int use;
void *attach; /* assigned memory address */
unsigned int msg_lengths[]={1,4,16,64,256,1024,4096,16384,65536,262144,524288};

void set_CPU_affinity(int num){
	// Define your cpu_set bit mask.
	cpu_set_t my_set;
	// Initialize it all to 0, i.e. no CPUs selected.
	CPU_ZERO(&my_set);
	// set the bit that represents core 7.
	CPU_SET(num, &my_set);
	// Set affinity of this process to the defined mask.
	sched_setaffinity(0, sizeof(cpu_set_t), &my_set);
}

int get_CPU_affinity(){
	// Define your cpu_set bit mask.
	cpu_set_t my_set;
	// Get affinity of this process to the defined mask.
	sched_getaffinity(0, sizeof(cpu_set_t), &my_set);
	return (int)(log(my_set.__bits[0])/log(2));
}

int get_frequency(int processor){
	int freq;
	char str[150];
	//printf("Processor: %d\n",processor);
	sprintf(str,"cat /proc/cpuinfo | grep MHz | head -n %d | tail -n 1 | rev | cut -d':' -f1 | rev | cut -d' ' -f2 > /tmp/a.txt",processor+1);
	//printf("Str: %s\n",str);
	system(str);
	FILE *fp = fopen("/tmp/a.txt", "r");
	fscanf(fp, "%d", &freq);
	//printf("Freq::: %d\n",freq);
	pclose(fp);
	return freq;
}

int main(){
	int n;
	fflush(stdout);
	time_shmem_latency();
	return 0;
}


void time_shmem_latency(){
	////////////////////////////////////////////////////////
	// For Shared Data Segment
	////////////////////////////////////////////////////////
	int perms = 0666;
	int oflags = O_CREAT | O_RDWR | O_TRUNC;
	int shm_fd;
	int mprot = PROT_READ | PROT_WRITE;
	int mflags = MAP_SHARED|MAP_HUGETLB;

	char* name="29";
	const size_t region_size = MAX_BUFF;

	shm_fd=shm_open(name,oflags,perms);
	if(shm_fd==-1){
		perror("shm_open failed\n");
		return;
	}

	assert(ftruncate(shm_fd,region_size)==0);

	attach=mmap(0,region_size,mprot,mflags,shm_fd,0);

	if(attach == MAP_FAILED){
		printf("Attach failed!\n");
		return;
	}

    int cpid;

    cpid = fork();
    if (cpid == -1) {
        perror("fork");
        exit(EXIT_FAILURE);
    }
    if (cpid == 0) {
    	// Setting CPU affinity
    	set_CPU_affinity(CHILD_PROCESSOR);

    	// Child will recv now
    	int i = 0;
    	char storage[MAX_BUFF];
    	for (i=NO_WARMUP;i<NUM_MSG; i++) {
			int j=0;
			for(j = 0;j < msg_lengths[i];j++){
				//storage[j] = get(&sdata->count);
			}
    	}

    } else {
    	// Setting CPU affinity and getting the corresponding frequency
    	set_CPU_affinity(PARENT_PROCESSOR);
    	freq=get_frequency(get_CPU_affinity());

    	int i = 0;
    	char storage[MAX_BUFF];
    	for(i=NO_WARMUP;i<NUM_MSG; i++) {

    		// Parent will send now
    		int j=0;
    		for(j = 0;j < msg_lengths[i];j++){
//    			put((char)((j % 26)+'A'),&sdata->count);
    		}
    	}
    	wait(NULL);

    	//Removing mappings
    	munmap(attach, region_size);

        if((shm_unlink(name)!=0)) {
            perror("In shm_unlink()");
            exit(1);
        }
    }
}

void put(char value, int *count){
	((char *)attach)[fill]=value;
	fill=(fill+1);
	(*count)++;
}

char get(int *count){
	char tmp=((char *) attach)[use];
	use=(use+1);
	(*count)--;
	return tmp;
}

