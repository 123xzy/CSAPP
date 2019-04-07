#include "csapp.h"



/* Recommended max cache and object sizes */
#define MAX_CACHE_SIZE 1049000
#define MAX_OBJECT_SIZE 1024000
#define MAX_BLOCK_SIZE 10

typedef struct cache_block{
	char cache_obj[MAX_OBJECT_SIZE];
	char url[MAXLINE];
	
	int reader_cnt;		/* cnt of readers */
	sem_t r_cnt_mutex;	/* mutex of reader_cnt */

	int writer_cnt; 	/* cnt of writers */
	sem_t w_cnt_mutex;	/* mutex of writer_cnt */
	
	struct cache_block *prev;
	struct cache_block *next;

}Cache_block;

typedef struct cache{

	Cache_block *head;
	Cache_block *tail;
	
	sem_t mutex;		/* protect all cache  when refresh the cache */
	sem_t size_mutex;	/* protect block_size */

	unsigned long max_size;	/* capaticity of cache */
	unsigned long block_size;	/* quantity of blocks */

}Cache;

/* cache API for users */
Cache_block *cache_find(Cache *cache,char *url);
void cache_write(Cache *cache,char *url,char *buf);
void cache_hits_refresh(Cache *cache,Cache_block *block);
Cache *cache_init(int capaticity);

/* Intern function */
void free_block(Cache_block *block);
Cache_block *create_block(char *url,char *obj);
void list_insert_head(Cache *cache,Cache_block *block);
void list_remove(Cache *cache,Cache_block *block);

void cache_test(Cache *cache);
