#include "uthash.h"
#include <stdlib.h>   /* malloc */
#include <stdio.h>    /* printf */

typedef struct example_user_t {
    int id;
    int cookie;
    UT_hash_handle hh;
    UT_hash_handle alth;
} example_user_t;

int ascending_sort(void *_a, void *_b) {
    example_user_t *a = (example_user_t*)_a;
    example_user_t *b = (example_user_t*)_b;
    if (a->id == b->id) return 0;
    return (a->id < b->id) ? -1 : 1;
}

int descending_sort(void *_a, void *_b) {
    example_user_t *a = (example_user_t*)_a;
    example_user_t *b = (example_user_t*)_b;
    if (a->id == b->id) return 0;
    return (a->id < b->id) ? 1 : -1;
}

int main() {
    int i;
    example_user_t *user, *users=NULL, *altusers=NULL, *tmp;

    /* create elements */
    for(i=0;i<1000;i++) {
        if ( (user = (example_user_t*)m_malloc(sizeof(example_user_t))) == NULL) exit(-1);
        user->id = i;
        user->cookie = i*i;
        if (i<10) HASH_ADD_INT(users,id,user);
        HASH_ADD(alth,altusers,id,sizeof(int),user);
    }

    printf("sorting users ascending\n");
    HASH_SRT(hh,users,ascending_sort);
    for(user=users; user; user=(example_user_t*)user->hh.next)
      printf("user %d\n", user->id);

    printf("sorting altusers descending\n");
    HASH_SRT(alth,altusers,descending_sort);
    for(user=altusers; user; user=(example_user_t*)user->alth.next)
      printf("altuser %d\n", user->id);

    /* HASH_FSCK(hh,users); */
    /* HASH_FSCK(alth,altusers); */
    
	/* free memory */
	HASH_ITER(hh, users, user, tmp) {
		HASH_DELETE(hh, users, user);     /* delete; users advances to next */
	}
	HASH_ITER(alth, altusers, user, tmp) {
		HASH_DELETE(alth, altusers, user);     /* delete; users advances to next */
		m_free(user);
	}
   
	return 0;
}
