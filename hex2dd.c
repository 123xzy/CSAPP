/*
 * change IP of HEX into dotted-dazimal
 * case : 0x8002c2f2
 */
#include "csapp.h"

int main(int argc,char **argv)
{
    struct in_addr inaddr;  /* address in network byte order */
    uint32_t addr;          /* address in host byte order */
    char buf[MAXBUF];       /* buffer for dotted-decimal string */

    if(argc != 2){
        fprintf(stderr,"usage: %s <hex number>\n",argv[0]);
        exit(0);
    }

    sscanf(argv[1],"%x",&addr);
    
    /* htonl:function can tansfer from host byte to network byte */ 
    inaddr.s_addr=htonl(addr);

    /* inet_ntop:function change inaddr into dotted-decimal */
    if(!inet_ntop(AF_INET,&inaddr,buf,MAXBUF))
        unix_error("inet_ntop");
    printf("%s\n",buf);

    exit(0);
}

