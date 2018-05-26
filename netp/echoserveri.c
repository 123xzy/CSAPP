/**
 * main program of echo server 
 */
#include "csapp.h"

void echo(int connfd)
{
    size_t n;
    char buf[MAXLINE];
    rio_t rio;

    rio_readinitb(&rio,connfd);
    while((n=rio_readlineb(&rio,buf,MAXLINE))!=0)
    {
        printf("server recrived %d bytes\n",(int)n);
        Rio_writen(connfd,buf,n);
    }

}

int main(int argc,char **argv)
{
    int listenfd,connfd;
    socklen_t clientlen;
    struct sockaddr_storage clientaddr; /* enough space for any address */
    char client_hostname[MAXLINE],client_port[MAXLINE];

    if(argc!=2){
        fprintf(stderr,"usage:%s <port> \n",argv[0]);
        exit(0);
    }
    
    int port=atoi(argv[1]);

    listenfd=Open_listenfd(port);
    while(1){
        clientlen=sizeof(struct sockaddr_storage);
        connfd=Accept(listenfd,(SA*)&clientaddr,&clientlen);
        getnameinfo((SA*)&clientaddr,clientlen,client_hostname,MAXLINE,
                    client_port,MAXLINE,0);
        printf("connected to (%s,%s)\n",client_hostname,client_port);
        echo(connfd);
        Close(connfd);
    }
    exit(0);
}


