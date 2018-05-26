/**
 * Use functions of write and read to realize I/O
 *
 * ssize_t read(int fd,void *buf,size_t n):
 * copy n bytes from fd to buf
 * 
 * ssize_t write(int fd,void *buf,size_t n):
 * copy n bytes from buf to fd
 *
 */

#include "csapp.h"

int main()
{
	char c;
	
	//SIDIN_FILENO and STDOUT_FILENO mean stdout and stdin
	while(Read(STDIN_FILENO,&c,1)!=0)
		Write(STDOUT_FILENO,&c,1);
	exit(0);
}
