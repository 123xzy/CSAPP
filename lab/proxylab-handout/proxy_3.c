/*
 * proxy_3.c
 *
 * author:xzy
 * data:2019.4.2
 */

#include <stdio.h>
#include "csapp.h"
#include "sbuf.h"
#include "cache.h"


/* max thread sizes */
#define NTHREADS 4

/* max buffer size */
#define SBUFSIZE 16

sbuf_t sbuf;/* shared buffer of connected descriptors */

/* You won't lose style points for including this long line in your code */
static const char *user_agent_hdr = "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120305 Firefox/10.0.3\r\n";
static const char *connection = "Connection:close\r\nProxy-Connection:close\r\n";

int conn_server(char *hostname,int *port,char *query_path);
int parse_url(char *url, char *hostname,char *query_path,int *port);
void *thread(void *vargp);

/* Intern function */
void free_block(Cache_block *block);
Cache_block *create_block(char *url,char *obj);
void list_insert_head(Cache *cache,Cache_block *block);
void list_remove(Cache *cache,Cache_block *block);

Cache *cache;

int main(int argc, char **argv) 
{
    int i;
    int listenfd, connfd;
    char hostname[MAXLINE],port[MAXLINE];
    socklen_t clientlen;
    struct sockaddr_storage clientaddr;
    pthread_t tid;


    /* Check command line args */
    if (argc != 2) {
	fprintf(stderr, "usage: %s <port>\n", argv[0]);
	exit(1);
    }

    listenfd = Open_listenfd(argv[1]);
    sbuf_init(&sbuf,SBUFSIZE);

    cache = cache_init(MAX_BLOCK_SIZE); 	/* initialize the cache with size */

    for(i = 0;i < NTHREADS;i++)
   	Pthread_create(&tid,NULL,thread,NULL);
 	
    while (1) {
	clientlen = sizeof(clientaddr);

	connfd = Accept(listenfd, (SA *)&clientaddr, &clientlen); //line:netp:tiny:accept        
    
    	sbuf_insert(&sbuf,connfd);
    }
}


/*
 * handle with HTTP header from client request
 * 1.Get the hostname,port of server to connect
 * 2.Edit the HTTP header and send info to real server
 */
void *thread(void *vargp)
{
	Pthread_detach(pthread_self());
	
	char buf[MAXLINE];

	// store the info of request
	char method[MAXLINE],url[MAXLINE],version[MAXLINE];

	char cache_buf[MAX_OBJECT_SIZE];

	// parse the url and store info here
	char hostname[MAXLINE],path[MAXLINE];
	int port;

	// rebuilt the http header 
	char realserver_http_header[MAXLINE];
	int real_serverfd;
	rio_t server_rio;

	rio_t proxy_rio;
	
	while(1){
		int connfd = sbuf_remove(&sbuf);

		Rio_readinitb(&proxy_rio,connfd);

		// read the request info from client(Browser)
		Rio_readlineb(&proxy_rio,buf,MAXLINE);
		sscanf(buf,"%s%s%s",method,url,version);

		// for test
		printf("%s %s %s\n",method,url,version);

		// proxy only support GET
		if(strcasecmp(method,"GET")){
			printf("Proxy only support 'GET'\n");
			return;
		}

		Cache_block *block;

		//if((block = cache_find(cache,url)) != NULL){
			/* exist in cache and refresh*/
		//	cache_hits_refresh(cache,block);

		//	strcpy(buf,block->cache_obj);
		//	printf("info from cache\n");
			/* return to client */
		//	Rio_writen(connfd,buf,strlen(buf));
		//}else{

			parse_url(url,hostname,path,&port);
	
			// rebulit the header which will send to the real server
			//built_http_header(realserver_http_header,hostname,path,port,&proxy_rio);

			// connect to the end server
			real_serverfd = conn_server(hostname,&port,path);
			if(real_serverfd < 0){
				printf("connected to real server failed\n");
				return;
			}	
			Rio_readinitb(&server_rio,real_serverfd);
			// write the http header to real server
			Rio_writen(real_serverfd,realserver_http_header,strlen(realserver_http_header));

			// receive message from real server and send to the client 
			size_t n;
			while((n = Rio_readlineb(&server_rio,buf,MAXLINE)) != 0){
				//printf("proxy received %d bytes\n",(int)n);
				Rio_writen(connfd,buf,n);
				if((strlen(cache_buf)+n) <= MAX_OBJECT_SIZE)
					strcat(cache_buf,buf);	
				//printf("%d %d\n",strlen(cache_buf),real_serverfd);	
			}

			/* store it */
			if(strlen(cache_buf) < MAX_OBJECT_SIZE){
				printf("cache %d from %s\n",strlen(cache_buf),url);
				cache_write(cache,url,cache_buf);
			}

		//}
	
		Close(real_serverfd);
		Close(connfd);
	}
}


/* 
 * fill the info of hostname,query_path,post about the specified url
 */
int parse_url(char *n_url,char *hostname,char *query_path,int *port)
{

	char *url;
	strcpy(url,n_url);

	char *ptr_1;

	// default port
	*port = 8080;

	// skip "http://" & "https://"
	ptr_1 = strstr(url,"//"); 	
	ptr_1 += 2;

	char *ptr_2 = strstr(ptr_1,":");

	if(ptr_2 != NULL){ // such as "www.xzy.com:8080/index.html"
		*ptr_2 = '\0';
		sscanf(ptr_1,"%s",hostname);
		sscanf(ptr_2 + 1,"%d %s",port,query_path);
	}else{ // such as "www.xzy.com/index.html
		ptr_2 = strstr(ptr_1,"/");
		if(ptr_2 != NULL) 
		{
			ptr_2[0] = '\0';
			sscanf(ptr_1,"%s",hostname);
			*ptr_2 = '/';
			sscanf(ptr_2,"%s",query_path);
		}else
			sscanf(ptr_1,"%s",hostname);
	}

	// for test
	//printf("%s %s %s %d\n",url,hostname,query_path,*port);
	return;	
}


/* 
 * connect to server,if failed return nagative num
 * or return socker fd
 */
int conn_server(char *hostname,int *port,char *query_path)
{
	int clientfd;
	char buf[MAXLINE];
	rio_t rio;
	char port_str[MAXLINE];
	sprintf(port_str,"%d",*port);

	//printf("connecting to %s:%d\n",hostname,*port);
	clientfd = Open_clientfd(hostname,port_str);	//built the connection to real server
	Rio_readinitb(&rio,clientfd);

	/* connection failed */
	if(clientfd < 0){
		printf("connection failed\n");
		return clientfd;
	}

	/* write request to server */
	sprintf(buf,"GET %s HTTP/1.0\r\n",query_path);
	Rio_writen(clientfd,buf,strlen(buf));
	sprintf(buf,"Host:%s\r\n",hostname);
	Rio_writen(clientfd,buf,strlen(buf));
	Rio_writen(clientfd,user_agent_hdr,strlen(user_agent_hdr));
	Rio_writen(clientfd,connection,strlen(connection));
	Rio_writen(clientfd,"\r\n",strlen("\r\n"));

	return clientfd;
}
