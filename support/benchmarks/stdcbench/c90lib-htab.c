/* This part of the benchmark is based on real-world code.
   Source: http://sdcc.sourceforge.net/

   (c) ?    - ?    Michael Hope
   (c) ?    - ?    Sandeep Dutta
   (c) ?    - ?    ?
   (c) ?    - ?    Johan Knol
   (c) ?    - ?    Bernhard Held
   (c) ?    - 2010 Borut Razem
   (c) 2018        Philipp Klaus Krause

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include "stdcbench.h"

#ifdef C90LIB

#include "c90lib-htab.h"

#include <string.h>

#define DEFAULT_HTAB_SIZE 32

void *
Safe_realloc (void *OldPtr, size_t NewSize)
{
  void *NewPtr;

  NewPtr = realloc (OldPtr, NewSize);

  if (!NewPtr)
    stdcbench_error("c90lib c90lib_peep(): realloc() failed\n");

  return NewPtr;
}

void *
Safe_calloc (size_t Elements, size_t Size)
{
  void *NewPtr;

  NewPtr = malloc (Elements * Size);

  if (!NewPtr)
    stdcbench_error("c90lib c90lib_peep(): malloc() failed\n");

  memset (NewPtr, 0, Elements * Size);

  return NewPtr;
}

void *
Safe_alloc (size_t Size)
{
  return Safe_calloc (1, Size);
}

void
Safe_free (void *p)
{
  free (p);


}

char *
Safe_strndup (const char *sz, size_t size)
{
  char *pret;

  pret = Safe_alloc (size + 1);
  strncpy (pret, sz, size);
  pret[size] = '\0';

  return pret;
}

char *
Safe_strdup (const char *sz)
{
  return Safe_strndup (sz, strlen (sz));
}

/*-----------------------------------------------------------------*/
/* newHashtItem - creates a new hashtable Item                     */
/*-----------------------------------------------------------------*/
static hashtItem *
_newHashtItem (int key, void *pkey, void *item)
{
  hashtItem *htip;

  htip = Safe_alloc ( sizeof (hashtItem));

  htip->key = key;
  htip->pkey = pkey;
  htip->item = item;
  htip->next = NULL;
  return htip;
}

/*-----------------------------------------------------------------*/
/* newHashTable - allocates a new hashtable of size                */
/*-----------------------------------------------------------------*/
hTab *
newHashTable (int size)
{
  hTab *htab;

  htab = Safe_alloc ( sizeof (hTab));

  if (!(htab->table = Safe_alloc ((size + 1) * sizeof (hashtItem *))))
    stdcbench_error("c90lib c90lib_peep(): out of virtual memory\n");

  htab->minKey = htab->size = size;
  return htab;
}

void 
hTabAddItemLong (hTab ** htab, int key, void *pkey, void *item)
{
  hashtItem *htip;
  hashtItem *last;

  if (!(*htab))
    *htab = newHashTable (DEFAULT_HTAB_SIZE);

  if (key > (*htab)->size)
    {
      int i;
      (*htab)->table = Safe_realloc ((*htab)->table,
				     (key * 2 + 2) * sizeof (hashtItem *));
      for (i = (*htab)->size + 1; i <= (key * 2 + 1); i++)
	(*htab)->table[i] = NULL;
      (*htab)->size = key * 2 + 1;
    }

  /* update the key */
  if ((*htab)->maxKey < key)
    (*htab)->maxKey = key;

  if ((*htab)->minKey > key)
    (*htab)->minKey = key;

  /* create the item */
  htip = _newHashtItem (key, pkey, item);

  /* if there is a clash then goto end of chain */
  if ((last = (*htab)->table[key]))
    {
      while (last->next)
	last = last->next;
      last->next = htip;
    }
  else
    /* else just add it */
    (*htab)->table[key] = htip;
  (*htab)->nItems++;
}

/*-----------------------------------------------------------------*/
/* hTabAddItem - adds an item to the hash table                    */
/*-----------------------------------------------------------------*/
void 
hTabAddItem (hTab ** htab, int key, void *item)
{
  hTabAddItemLong (htab, key, NULL, item);
}

/*-----------------------------------------------------------------*/
/* hTabDeleteAll - deletes all items in a hash table to reduce mem */
/*                 leaks written by                                */
/*                "BESSIERE Jerome" <BESSIERE_Jerome@stna.dgac.fr> */
/*-----------------------------------------------------------------*/
void 
hTabDeleteAll (hTab * p)
{
  if (p && p->table)
    {
      register int i;
      register hashtItem *jc, *jn;
      for (i = 0; i < p->size; i++)
	{

	  if (!(jc = p->table[i]))
	    continue;
	  jn = jc->next;
	  while (jc)
	    {
	      Safe_free (jc);
	      if ((jc = jn))
		jn = jc->next;
	    }
	  p->table[i] = NULL;
	}
      Safe_free (p->table);
    }
}

/*-----------------------------------------------------------------*/
/* hTabSearch - returns the first Item with the specified key      */
/*-----------------------------------------------------------------*/
hashtItem *
hTabSearch (hTab * htab, int key)
{
  if (!htab)
    return NULL;

  if ((key < htab->minKey) || (key > htab->maxKey))
    return NULL;

  if (!htab->table[key])
    return NULL;

  return htab->table[key];
}

/*-----------------------------------------------------------------*/
/* hTabItemWithKey - returns the first item with the given key     */
/*-----------------------------------------------------------------*/
void *
hTabItemWithKey (hTab * htab, int key)
{
  hashtItem *htip;

  if (!(htip = hTabSearch (htab, key)))
    return NULL;

  return htip->item;
}

/*-----------------------------------------------------------------*/
/* hTabFirstItem - returns the first Item in the hTab              */
/*-----------------------------------------------------------------*/
void *
hTabFirstItem (hTab * htab, int *k)
{
  int key;

  if (!htab)
    return NULL;

  for (key = htab->minKey; key <= htab->maxKey; key++)
    {
      if (htab->table[key])
	{
	  htab->currItem = htab->table[key];
	  htab->currKey = key;
	  *k = key;
	  return htab->table[key]->item;
	}
    }
  return NULL;
}

/*-----------------------------------------------------------------*/
/* hTabNextItem - returns the next item in the hTab                */
/*-----------------------------------------------------------------*/
void *
hTabNextItem (hTab * htab, int *k)
{
  int key;

  if (!htab)
    return NULL;

  /* if this chain not ended then */
  if (htab->currItem->next)
    {
      *k = htab->currItem->key;
      return (htab->currItem = htab->currItem->next)->item;
    }

  /* find the next chain which has something */
  for (key = htab->currKey + 1; key <= htab->maxKey; key++)
    {
      if (htab->table[key])
	{
	  htab->currItem = htab->table[key];
	  *k = htab->currKey = key;
	  return htab->table[key]->item;
	}
    }

  return NULL;
}

#endif

