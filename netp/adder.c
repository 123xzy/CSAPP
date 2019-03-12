#include "csapp.h"

int main(void)
{
	char *buf,*p;
	char arg1[MAXLINE],arg2[MAXLINE],content[MAXLINE];
	int n1=0,n2=0;

	/* Extract the two argument */
	if((buf = getenv("QUERY_STRING")) != NULL){
		p = strchr(buf,'&');
		*p = '/0';
		strcpy(arg1,buf);
		strcpy(arg2,p + 1);
		n1 = atoi(arg1);
		n2 = atoi(arg2);
	}

	/* Make the response body */
	sprintf(content,"QUERY_STRING=%s",buf);
	sprintf(content,"%sThe answer is %d + %d = %d\r\n<p>",
			content,n1,n2,n1 + n2);
	
	exit(0);
}

