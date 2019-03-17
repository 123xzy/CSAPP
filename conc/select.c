#include "csapp.h"

void echo(int connfd);
void command(void);

int main(int argc,char **argv)
{
	int listenfd,connfd;
	int port;
	socklen_t clientlen;
	struct sockaddr_storage clientaddr;
	fd_set read_set,ready_set;

	port = atoi(argv[1]);

	if(argc != 2){
		fprintf(stderr,"usage:%s <port>\n",argv[0]);
		exit(0);
	}

	listenfd = Open_listenfd(port);
	
	FD_ZERO(&read_set);      	// clear read set
	FD_SET(STDIN_FILENO,&read_set); // add stdin to read set
	FD_SET(listenfd,&read_set);     // add listenfd to read set
	
	while(1){
		ready_set = read_set;		
		Select(listenfd+1,&ready_set,NULL,NULL,NULL);

		if(FD_ISSET(STDIN_FILENO,&ready_set))
			command();      // read command line from stdin
		if(FD_ISSET(listenfd,&ready_set)){
			clientlen = sizeof(struct sockaddr_storage);
			connfd = Accept(listenfd,(SA *)&clientaddr,&clientlen);
			echo(connfd);   // echo client input util EOF
			Close(connfd);
		}
	}
}

void echo(int connfd)
{
	size_t n;
	char buf[MAXLINE];
	rio_t rio;

	Rio_readinitb(&rio,connfd);
	while((n = Rio_readlineb(&rio,buf,MAXLINE)) != 0){
		printf("server received %d bytes\n",(int)n);
		Rio_writen(connfd,buf,n);
	}
}

void command(void){
	char buf[MAXLINE];
	if(!Fgets(buf,MAXLINE,stdin))
		exit(0);              // EOF
	printf("%s",buf);	      // process the input command
}
