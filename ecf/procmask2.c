/* WARNING: This code is buggy */
#include "../csapp.h"

void deletejob(pid_t pid){}
void addjobs(pid_t pid){}
void initjobs(){}

void handler(int sig)
{
	int olderrno = errno;
	sigset_t mask_all,prev_all;
	pid_t pid;

	Sigfillset(&mask_all);
	while((pid = waitpid(-1,NULL,0)) > 0){
		Sigprocmask(SIG_BLOCK,&mask_all,&prev_all);
		deletejob(pid);
		Sigprocmask(SIG_SETMASK,&prev_all,NULL);
	}

	if(errno != ECHILD)
		unix_error("Waitpid error");
	errno = olderrno;
}

int main(int argc,char **argv)
{
	int pid;
	sigset_t mask_all,prev_one,mask_one;

	Sigfillset(&mask_all);
	Sigemptyset(&mask_one);
	Sigaddset(&mask_one,SIGCHLD);
	Signal(SIGCHLD,handler);
	initjobs();	/* Initialize the job list */

	while(1){
		Sigprocmask(SIG_BLOCK,&mask_one,&prev_one);	/* Block SIGCHLD */
		if((pid = Fork()) == 0){
			Sigprocmask(SIG_SETMASK,&prev_one,NULL); /*Unblock SIGCHLD */
			Execve("/bin/date",argv,NULL);
		}
		Sigprocmask(SIG_BLOCK,&mask_all,&NULL);
		addjobs(pid);
		Sigprocmask(SIG_SETMASK,&prev_one,NULL);	/* Unblock SIGCHLD */
	}
	exit(0);
}	
