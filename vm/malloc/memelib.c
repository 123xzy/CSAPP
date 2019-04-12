#include "../../csapp.h"

/* private global variables */
static char *mem_heap;		/* points to first byte of heap */
static char *mem_brk;		/* points to last byte of heap plus 1 */
static char *mem_max_addr;	/* max legal heap addr plus 1 */

/*
 * mem_init:initialize the memory systems model 
 */
void mem_init(void)
{
	mem_heap = (char *)Malloc(MAX_HEAP);
	mem_brk = mem_heap;
	mem_max_addr = (char *)(mem_heap + MAX_HEAP);
}

/* 
 * mem_brk:simple model of the sbrk function.Extends the heap
 *	 by incr bytes and returns the start address of the 
 *	 new area.In this model,the heap connot be shrunk.
 */
void mem_sbrk(int inrc)
{
	char *old_brk = mem_sbrk;

	if((inrc < 0) || ((mem_brk + inrc) > mem_max_addr)){
		errno = ENOMEM;
		fprintf(stderr,"Error:mem_sbrk failed.Run out of memory...\n");
		return (void*)-1;
	}
	mem_brk += inrc;
	return (void*)old_brk;
}

