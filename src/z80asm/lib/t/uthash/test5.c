#include "uthash.h"
#include <stdlib.h>   /* malloc */
#include <stdio.h>    /* printf */

typedef struct example_user_t {
    int id;
    int cookie;
    UT_hash_handle hh;
    UT_hash_handle alth;
} example_user_t;

int main() {
    int i,j;
    example_user_t *user, *tmp, *users=NULL, *altusers=NULL;

    /* create elements */
    for(i=0;i<10;i++) {
        if ( (user = (example_user_t*)m_malloc(sizeof(example_user_t))) == NULL) exit(-1);
        user->id = i;
        user->cookie = i*i;
        HASH_ADD_INT(users,id,user);
        HASH_ADD(alth,altusers,cookie,sizeof(int),user);
    }

    /* find cookie corresponding to each even ID */
    for(i=0;i<10;i+=2) {
        j=i*i;
        HASH_FIND(alth,altusers,&j,sizeof(int),tmp);
        if (tmp) printf("cookie %d found, user id %d\n", tmp->cookie, tmp->id);
        else printf("cookie %d not found\n", j);
    }
    
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
