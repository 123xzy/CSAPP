#include "csapp.h"

#define MAXTHREADS 32

void *sum_array(void *vargp);

long psum[10];
long nelems_per_thread;

int main(int argc,char **argv)
{
	long i,nelems,log_nelems,nthreads,myid[MAXTHREADS];

	long sum;

	pthread_t tid[MAXTHREADS];

	if(argc != 3){
		printf("usage:%s <nthreads> <log_nelems>\n",argv[0]);
		exit(0);
	}

	nthreads = atoi(argv[1]);
	log_nelems = atoi(argv[2]);
	nelems = (1L << log_nelems);
	nelems_per_thread = nelems / nthreads;
	printf("%ld %ld\n",nelems,nelems_per_thread);

	//psum = malloc(sizeof(int) * nthreads);

	for(i = 0;i < nthreads;i++){
		myid[i] = i;
		Pthread_create(&tid[i],NULL,sum_array,&myid[i]);
	}

	for(i = 0 ;i < nthreads;i++)
		Pthread_join(tid[i],NULL);

	for(i = 0;i < nthreads;i++)
		sum += psum[i];

	if(sum != (nelems * (nelems - 1)) / 2)
		printf("error:result = %ld right = %ld\n",sum,nelems * (nelems - 1) / 2);

	Pthread_exit(NULL);

	exit(0);
}

void *sum_array(void *vargp)
{
	long myid = *((long *)vargp);
	long start = myid * nelems_per_thread;
	long end = start + nelems_per_thread;
	long i;

	for(i = start;i < end;i++){
		psum[myid] += i;
	}

	return NULL;
}
