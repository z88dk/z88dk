#include <stdlib.h>

void Safe_free (void *p);
char *Safe_strdup (const char *sz);
void *Safe_alloc (size_t Size);

/* hashtable item */
typedef struct hashtItem
  {
    int key;
    /* Pointer to the key that was hashed for key.
       Used for a hash table with unique keys. */
    void *pkey;
    void *item;
    struct hashtItem *next;
  }
hashtItem;

/* hashtable */
typedef struct hTab
  {
    int size;			/* max number of items */
    int minKey;			/* minimum key value   */
    int maxKey;			/* maximum key value */
    hashtItem **table;		/* the actual table  */
    int currKey;		/* used for iteration */
    hashtItem *currItem;	/* current item within the list */
    int nItems;
  }
hTab;

hTab *newHashTable (int);
void hTabAddItem (hTab **, int key, void *item);
void *hTabItemWithKey (hTab *, int);
void *hTabFirstItem (hTab *, int *);
void *hTabNextItem (hTab *, int *);
void hTabDeleteAll (hTab *);

