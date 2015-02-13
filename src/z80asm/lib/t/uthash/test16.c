#include <stdlib.h>    /* malloc       */
#include <stddef.h>    /* offsetof     */
#include <stdio.h>     /* printf       */
#include <string.h>    /* memset       */
#include "uthash.h"

struct inner {
    int a;
    int b;
};

struct my_event {
    struct inner is;           /* key is aggregate of this field */
    char event_code;           /* and this field.                */
    int user_id;
    UT_hash_handle hh;         /* makes this structure hashable */
};


int main() {
    struct my_event *e, ev, *events = NULL, *tmp;
    unsigned i, keylen;

    keylen =   offsetof(struct my_event, event_code) + sizeof(char)
             - offsetof(struct my_event, is);

    for(i = 0; i < 10; i++) {
        e = (struct my_event*)m_malloc(sizeof(struct my_event));
        memset(e,0,sizeof(struct my_event));
        e->is.a = i * (60*60*24*365);          /* i years (sec)*/
        e->is.b = 0;
        e->event_code = 'a'+(i%2);              /* meaningless */
        e->user_id = i;

        HASH_ADD( hh, events, is, keylen, e);
    }

    /* look for one specific event */
    memset(&ev,0,sizeof(struct my_event));
    ev.is.a = 5 * (60*60*24*365);
    ev.is.b = 0;
    ev.event_code = 'b';
    HASH_FIND( hh, events, &ev.is, keylen , e);
    if (e) printf("found: user %d, unix time %d\n", e->user_id, e->is.a);
	
	/* free memory */
	HASH_ITER(hh, events, e, tmp) {
		HASH_DEL(events, e);     /* delete; events advances to next */
		m_free(e);
	}
   
	return 0;
}
