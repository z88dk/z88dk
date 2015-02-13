#include <stdlib.h>
#include <stdio.h>
#include "uthash.h"

typedef struct hs_t {
    int id;
    int tag;
    UT_hash_handle hh;
} hs_t;


static void pr(hs_t **hdpp){
  hs_t *el, *tmp, *hdp = *hdpp;
  HASH_ITER(hh, hdp, el, tmp){
    printf("id %d, tag %d\n",el->id,el->tag);
  }
}

int main() {

  hs_t *hs_head=NULL, *hs, *tmp, *replaced=NULL;

  tmp = (hs_t*)m_malloc(sizeof(hs_t));
  tmp->id = 10;
  tmp->tag = 100;
  HASH_REPLACE_INT(hs_head,id,tmp,replaced);
  if(replaced == NULL)
    printf("added %d %d\n",tmp->id,tmp->tag);
  else
    printf("ERROR, ended up replacing a value, replaced: %p\n",replaced);
  m_free(replaced);
  
  pr(&hs_head);

  tmp = (hs_t*)m_malloc(sizeof(hs_t));
  tmp->id=11;
  tmp->tag = 101;
  HASH_REPLACE_INT(hs_head,id,tmp,replaced);
  if(replaced == NULL)
    printf("added %d %d\n",tmp->id,tmp->tag);
  else
    printf("ERROR, ended up replacing a value, replaced: %p\n",replaced);
  m_free(replaced);

  pr(&hs_head);

  tmp = (hs_t*)m_malloc(sizeof(hs_t));
  tmp->id=11;
  tmp->tag = 102;
  HASH_REPLACE_INT(hs_head,id,tmp,replaced);
  if(replaced == NULL)
    printf("ERROR, exected to replace a value with key: %d\n",tmp->id);
  else
    printf("replaced %d that had tag %d with tag %d\n",tmp->id,replaced->tag,tmp->tag);
  m_free(replaced);

  pr(&hs_head);

  /* free memory */
  HASH_ITER(hh, hs_head, hs, tmp) {
	HASH_DEL(hs_head, hs);     /* delete; users advances to next */
	m_free(hs);
  }
  
  return 0;
}
