#include "cache.h"

/************************
 * Cache function 
 * **********************/

Cache *cache_init(int capaticity)
{
	int i;
	Cache *cache;

	if((cache = Malloc(sizeof(Cache))) == NULL)
		return NULL;
	
	Sem_init(&(cache->mutex),0,1);
	Sem_init(&(cache->size_mutex),0,0);

	cache->head = cache->tail = NULL;
	cache->max_size = capaticity;

	cache->block_size = 0;
		
	return cache;
}

/* 
 * find url in cache
 * if not,return null
 */
Cache_block *cache_find(Cache *cache,char *url)
{
	Cache_block *block;

	block = cache->head;

	while(block != NULL)
	{
		P(&block->r_cnt_mutex);
		block->reader_cnt++;
		if(block->reader_cnt == 1) 	/* first in */
			P(&block->w_cnt_mutex);
		V(&block->r_cnt_mutex);

		if(strcmp(url,block->url))
			break;

		P(&block->r_cnt_mutex);
		block->reader_cnt--;
		if(block->reader_cnt == 0)	/* last out */
			V(&block->w_cnt_mutex);
		V(&(block->r_cnt_mutex));


		block = block->next;
		
	}

	return block;
}

/* 
 * write new url into cache 
 */
void cache_write(Cache *cache,char *url,char *buf)
{
	Cache_block *block;
	block = create_block(url,buf);

	/* reach max capaticity and remove the tail of cache */
	P(&(cache->mutex));
	if(cache->block_size == MAX_BLOCK_SIZE)
	{
		list_remove(cache,cache->tail);
		Free(cache->tail);
	}
	V(&(cache->mutex));

	list_insert_head(cache,block);
}


void cache_hits_refresh(Cache *cache,Cache_block *block)
{
	list_remove(cache,block);

	list_insert_head(cache,block);
}


/* notice:memory of block not free here */
void list_remove(Cache *cache,Cache_block *block)
{

	if(cache->block_size == 0)
		return;

	/* block is head */
	if(cache->head == block){
		P(&(cache->mutex));
		cache->head = block->next;
		cache->head->prev = NULL;
		V(&(cache->mutex));
	}
	/* block is tail */
	else if(block = cache->tail){
		P(&(cache->mutex));
		cache->tail = block->prev;
		cache->tail->next = NULL;
		V(&(cache->mutex));
	}
	else {
		P(&(cache->mutex));
		block->prev->next = block->next;
		block->next->prev = block->prev;
		V(&(cache->mutex));
	}

	P(&(cache->mutex));
	cache->block_size--;
	V(&(cache->mutex));
}

void list_insert_head(Cache *cache,Cache_block *block)
{
	if(cache->block_size == cache->max_size){
		/* remove the block that has been accessed for a long time */
		list_remove(cache,cache->tail);
	}	

	
	/* empty cache*/
	if(cache->head == NULL && cache->tail == NULL){
		P(&(cache->mutex));
		cache->head = cache->tail = block;
		V(&(cache->mutex));
	}
	else{
		P(&(cache->mutex));
		block->next = cache->head;
		block->prev = NULL;
		cache->head->prev = block;
		cache->head = block;
		V(&(cache->mutex));
	}

}

Cache_block *create_block(char *url,char *obj)
{
	Cache_block *block;
	if((block = Malloc(sizeof(Cache_block))) == NULL)
		return NULL;

	strncpy(block->url,url,strlen(url));
	strncpy(block->cache_obj,obj,strlen(obj));

	Sem_init(&(block->r_cnt_mutex),0,1);
	Sem_init(&(block->w_cnt_mutex),0,1);

	block->writer_cnt = 0;
	block->reader_cnt = 0;

	return block;
}

void free_block(Cache_block *block)
{
	if(block == NULL){
		printf("free failed\n");
		return;
	}
	Free(block);
}	
