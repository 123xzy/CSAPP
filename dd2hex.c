/*
 * case:128.2.194.242
 */
#include "csapp.h"

int main(int argc,char **argv)
{
    struct in_addr inaddr;  /* address in network byte order */
    int rc;
     
    if(argc != 2){
        fprintf(stderr,"usage:%s <dotted-decimal>\n",argv[0]);
        exit(0);
    }
    
    /* inet_pton:function transfer dotted-decimal into network byte */
    rc=inet_pton(AF_INET,argv[1],&inaddr);
    if(rc==0)
        app_error("inet_pton error:invalid dooted-decimal address");
    else if(rc<0)
        unix_error("inet_pton error");

    /* ntohl:function change network byte into host byte */
    printf("0x%x\n",ntohl(inaddr.s_addr));
    exit(0);

}
