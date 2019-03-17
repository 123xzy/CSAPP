#include "csapp.h"


typedef struct{ /* represents a pool of connected descriptors */
	int maxfd; // largest descriptor in read_set
	fd_set read_set;// set of all active descriptors
	fd_set ready_set;
	int nready;
	int maxi;
	int clientfd[FD_SETSIZE];
	rio_t clientrio[FD_SETSIZE];
}pool;

void init_pool(int,pool *);
void add_client(int,pool *);
void check_clients(pool *);

int byte_cnt = 0; // counts total bytes received by server 

int main(int argc,char **argv)
{
	int listenfd,connfd;
	int port;
	socklen_t clientlen;
	struct sockaddr_storage clientaddr;

	static pool pool;

	port = atoi(argv[1]);

	if(argc != 2){
		fprintf(stderr,"usage:%s <port>\n",argv[0]);
		exit(0);
	}

	listenfd = Open_listenfd(port);
	init_pool(listenfd,&pool);

	while(1){
		/* wait for listening/connected descriptor to become ready */
		pool.ready_set = pool.read_set;
		pool.nready = Select(pool.maxfd+1,&pool.ready_set,NULL,NULL,NULL);

		/* if listening descriptor ready,add new client to pool */
		if(FD_ISSET(listenfd,&pool.ready_set)){
			clientlen = sizeof(struct sockaddr_storage);
			connfd = Accept(listenfd,(SA *)&clientaddr,&clientlen);
			add_client(connfd,&pool);
		}

		/* echo a text line from each ready connected descriptor */
		check_clients(&pool);
	}
	
}

void init_pool(int listenfd,pool *p)
{
	int i;
	p->maxi = -1;
	for(i = 0;i < FD_SETSIZE;i++)
		p->clientfd[i] = -1;

	p->maxfd = listenfd;
	FD_ZERO(&p->read_set);
	FD_SET(listenfd,&p->read_set);
}

void add_client(int connfd,pool *p)
{
	int i;
	p->nready--;
	for(i = 0;i < FD_SETSIZE;i++)
		if(p->clientfd[i] < 0){
			p->clientfd[i] = connfd;
			Rio_readinitb(&p->clientrio[i],connfd);

			FD_SET(connfd,&p->read_set);

			if(connfd > p->maxfd)
				p->maxfd = connfd;
			if(i > p->maxi)
				p->maxi = i;
			break;
		}
	if(i == FD_SETSIZE)
		app_error("add_client error:Too many clients");
}

void check_clients(pool *p)
{
	int i,connfd,n;
	char buf[MAXLINE];
	rio_t rio;

	for(i = 0;(i <= p->maxi) && (p->nready > 0);i++){
		connfd = p->clientfd[i];
		rio = p->clientrio[i];

		if((connfd > 0) && (FD_ISSET(connfd,&p->ready_set))){
			p->nready--;
			if((n = Rio_readlineb(&rio,buf,MAXLINE)) != 0){
				byte_cnt += n;
				printf("Server received %d (%d total) bytes on fd %d\n",
						n,byte_cnt,connfd);
				Rio_writen(connfd,buf,n);
			}

			else{
				Close(connfd);
				FD_CLR(connfd,&p->read_set);
				p->clientfd[i] = -1;
			}
		}
	}
}
