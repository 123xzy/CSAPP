#ifndef _SBUF_H
#define _SBUF_H

typedef struct{
	int *buf;   /* buffer array */
    	int n;      /* maximun number of slots */
	int front;  /* buf[(front+1)%n] is first item */
    	int rear;   /* buf[rear%n] is last item */
    	sem_t mutex;/* protects accesses to buf */
     	sem_t slots;/* counts available slots */
    	sem_t items;/* counts available items */
}sbuf_t;

#endif
