#include<sys/types.h>
#include<stdlib.h>
#include<stdio.h>
#include<csapp.h>

int main()
{
    pid_t pid;
    int x=1;

    //fork will return twice,return 0 in subprocess 
    //and return PID of subprocess in parentprocess
    pid=Fork();           
    printf("pid=%d\n",pid);

    if(pid==0){             
        printf("child:x=%d\n",++x);
        exit(0);
    }

    printf("parent:x=%d\n",--x);
    exit(0);
}
