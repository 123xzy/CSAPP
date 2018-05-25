/* WARNING:this code is buggy 
 * synchronization error
 * two thread all add cnt for niters times
 * so we guess cnt maybe 2*niters,but answer is not and it change everytime
 * use case:"./badcnt 10000"
 */
#include "csapp.h"

void *thread(void *vargp);

volatile long cnt=0;

int main(int argc,char **argv)
{
    long niters;
    pthread_t tid1,tid2;

    if(argc!=2)
    {
        printf("usage:%s<niters>\n",argv[0]);
        exit(0);
    }

    niters=atoi(argv[1]);   /* change char* into long type */

    Pthread_create(&tid1,NULL,thread,&niters);
    Pthread_create(&tid2,NULL,thread,&niters);
    Pthread_join(tid1,NULL);
    Pthread_join(tid2,NULL);

    if(cnt!=(2*niters))
        printf("BOOM!cnt=%ld\n",cnt);
    else
        printf("OK!cnt=%ld\n",cnt);
    exit(0);
}

void  *thread(void *vargp)
{
    long i,niters=*((long *)vargp);
    for(i=0;i<niters;i++)
        cnt++;
    return NULL;
}

