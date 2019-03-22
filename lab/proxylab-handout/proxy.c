/*
 * proxy.c
 */
#include <stdio.h>
#include "csapp.h"

/* Recommended max cache and object sizes */
#define MAX_CACHE_SIZE 1049000
#define MAX_OBJECT_SIZE 102400

/* You won't lose style points for including this long line in your code */
static const char *user_agent_hdr = "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120305 Firefox/10.0.3\r\n";

void read_requesthdrs(rio_t *rp);
void clienterror(int fd, char *cause, char *errnum, 
		 char *shortmsg, char *longmsg);
int conn_server(char *url,char *hostname,char *query_path,int *port);
int parse_url(char *url, char *hostname,char *query_path,int *port);
void doit(int connfd);

int main(int argc, char **argv) 
{
    int listenfd, connfd;
    char hostname[MAXLINE], port[MAXLINE];
    socklen_t clientlen;
    struct sockaddr_storage clientaddr;

    /* Check command line args */
    if (argc != 2) {
	fprintf(stderr, "usage: %s <port>\n", argv[0]);
	exit(1);
    }

    listenfd = Open_listenfd(argv[1]);
    while (1) {
	clientlen = sizeof(clientaddr);

	connfd = Accept(listenfd, (SA *)&clientaddr, &clientlen); //line:netp:tiny:accept        

	Getnameinfo((SA *)clientaddr,clientlen,hostname,MAXLINE,port,MAXLINE,0);// fill the info with socket addr. 
	printf("Accepted connection from Browser (%s, %s)\n", hostname, port);
	
	doit(connfd);                                             //line:netp:tiny:doit
	Close(connfd);                                            //line:netp:tiny:close
    }
}
/* $end tinymain */


/*
 * handle with HTTP header from client request
 * 1.Get the hostname,port of server to connect
 * 2.Edit the HTTP header and send info to real server
 */
void doit(int connfd)
{
	
}



/*
 * read_requesthdrs - read HTTP request headers
 */
/* $begin read_requesthdrs */
void read_requesthdrs(rio_t *rp) 
{
    char buf[MAXLINE];

    Rio_readlineb(rp, buf, MAXLINE);
    printf("%s", buf);
    while(strcmp(buf, "\r\n")) {          //line:netp:readhdrs:checkterm
	Rio_readlineb(rp, buf, MAXLINE);
	printf("%s", buf);
    }
    return;
}
/* $end read_requesthdrs */





/* 
 * fill the info of hostname,query_path,post about the specified url
 */
int parse_uri(char *url,char *hostname,char *query_path,int *post)
{
	
}


/*
 * clienterror - returns an error message to the client
 */
/* $begin clienterror */
void clienterror(int fd, char *cause, char *errnum, 
		 char *shortmsg, char *longmsg) 
{
    char buf[MAXLINE], body[MAXBUF];

    /* Build the HTTP response body */
    sprintf(body, "<html><title>Tiny Error</title>");
    sprintf(body, "%s<body bgcolor=""ffffff"">\r\n", body);
    sprintf(body, "%s%s: %s\r\n", body, errnum, shortmsg);
    sprintf(body, "%s<p>%s: %s\r\n", body, longmsg, cause);
    sprintf(body, "%s<hr><em>The Tiny Web server</em>\r\n", body);

    /* Print the HTTP response */
    sprintf(buf, "HTTP/1.0 %s %s\r\n", errnum, shortmsg);
    Rio_writen(fd, buf, strlen(buf));
    sprintf(buf, "Content-type: text/html\r\n");
    Rio_writen(fd, buf, strlen(buf));
    sprintf(buf, "Content-length: %d\r\n\r\n", (int)strlen(body));
    Rio_writen(fd, buf, strlen(buf));
    Rio_writen(fd, body, strlen(body));
}
/* $end clienterror */



/* 
 * connect to server,if failed return nagative num
 * or return socker fd
 */
int conn_server(char *hostname,int port,char *query_path)
{
	int clientfd;
	char buf[MAXLINE];
	rio_t rio;

	clientfd = Open_clientfd(hostname,port);	//built the connection to real server
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
	return clientfd;
}
