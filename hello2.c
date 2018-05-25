/*
 * Posix thread us standard API in c
 * in this program,main thread create a peer thread 
 * peer thread printf "hello world" and end
 */
#include "csapp.h"

void *thread(void *vargp);

int main()
{
    pthread_t tid;          /* new thread's ID */
    Pthread_create(&tid,NULL,thread,NULL);
    Pthread_join(tid,NULL);

    printf("%d\n",tid);     /* printf new thread's ID */
    printf("%d\n",tid=pthread_self());/*printf main thread's ID */

    exit(0);
}

void *thread(void *vargp)
{
    printf("hello world\n");
    return NULL;
}

