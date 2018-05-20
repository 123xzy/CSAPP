/*
 * functions:getaddrinfo,getnameinfo
 * show relation with IP address and domain name 
 * case:0x45fafaf 
 */
#include "csapp.h"

int main(int argc,char **argv)
{
    struct addrinfo *p,*listp,hints;
    struct sockaddr_in *sockp;
    char buf[MAXLINE];
    int rc,flags;

    if(argc!=2){
        fprintf(stderr,"usage:%s <domain name>\n",argv[0]);
        exit(0);
    }

    /* get a list of addrinfo records */
    memset(&hints,0,sizeof(struct addrinfo));
    hints.ai_family=AF_INET;                    /* IPv4 only */
    hints.ai_socktype=SOCK_STREAM;              /* connections only */

    if((rc=getaddrinfo(argv[1],NULL,&hints,&listp))!=0){
        fprintf(stderr,"getaddrinfo error:%s\n",gai_strerror(rc));
        exit(1);
    }

    /* walk the list and display each IP address */
    flags=NI_NUMERICHOST;                       /* display address string instead of domain nane */
    for(p=listp;p;p=p->ai_next){
        sockp=(struct sockadd_in *)p->ai_addr;
        inet_ntop(AF_INET,&(sockp->sin_addr),buf,MAXLINE);
        printf("%s\n",buf);
    }

    /* clear up */
    freeaddrinfo(listp);

    exit(0);

}
