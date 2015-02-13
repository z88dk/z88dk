#include <string.h>
#include <stdio.h>
#include "uthash.h"

// this is an example of how to do a LRU cache in C using uthash
// http://troydhanson.github.com/uthash/
// by Jehiah Czebotar 2011 - jehiah@gmail.com
// this code is in the public domain http://unlicense.org/

#define MAX_CACHE_SIZE 50  /* a real value would be much larger */

struct CacheEntry {
    char *key;
    char *value;
    UT_hash_handle hh;
};
struct CacheEntry *cache = NULL;

char * /*value*/ find_in_cache(char *key)
{
    struct CacheEntry *entry;
    HASH_FIND_STR(cache, key, entry);
    if (entry) {
        // remove it (so the subsequent add will throw it on the front of the list)
        HASH_DELETE(hh, cache, entry);
        HASH_ADD_KEYPTR(hh, cache, entry->key, strlen(entry->key), entry);
        return entry->value;
    }
    return NULL;
}

void add_to_cache(char *key, char *value)
{
    struct CacheEntry *entry, *tmp_entry;
    entry = m_malloc(sizeof(struct CacheEntry));
    entry->key = m_strdup(key);
    entry->value = m_strdup(value);
    HASH_ADD_KEYPTR(hh, cache, entry->key, strlen(entry->key), entry);

    // prune the cache to MAX_CACHE_SIZE
    if (HASH_COUNT(cache) >= MAX_CACHE_SIZE) {
        HASH_ITER(hh, cache, entry, tmp_entry) {
            // prune the first entry (loop is based on insertion order so this deletes the oldest item)
            printf("LRU deleting %s %s\n", entry->key, entry->value);
            HASH_DELETE(hh, cache, entry);
            m_free(entry->key);
            m_free(entry->value);
            m_free(entry);
            break;
        }
    }
}

/* main added by Troy D. Hanson */
int main() {
  struct CacheEntry *entry, *tmp_entry;
  char linebuf[100], nbuf[10];
  FILE *file;
  int i=0;

  if ( (file = fopen( "test65.dat", "r" )) == NULL ) {
      perror("can't open: ");
      exit(-1);
  }

  while (fgets(linebuf,sizeof(linebuf),file) != NULL) {
    snprintf(nbuf,sizeof(nbuf),"%u",i++);
    add_to_cache(linebuf, nbuf);
  }

  fclose(file);
  
  /* free memory */
  HASH_ITER(hh, cache, entry, tmp_entry) {
	HASH_DELETE(hh, cache, entry);
	m_free(entry->key);
	m_free(entry->value);
	m_free(entry);
  }
  
  return 0;
}
