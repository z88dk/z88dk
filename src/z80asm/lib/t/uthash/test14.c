#include "uthash.h"
#include <stdlib.h>   /* malloc */
#include <errno.h>    /* perror */
#include <stdio.h>    /* printf */

#define BUFLEN 20
#if 0
#undef uthash_expand_fyi
#define uthash_expand_fyi(tbl) printf("expanding to %d buckets\n", tbl->num_buckets)
#endif

typedef struct name_rec {
    char boy_name[BUFLEN];
    UT_hash_handle hh;
} name_rec;

int main() {
    name_rec *name, *names=NULL, *tmp;
    char linebuf[BUFLEN];
    FILE *file;
    int i=0,j=0;

    if ( (file = fopen( "test14.dat", "r" )) == NULL ) {
        perror("can't open: ");
        exit(-1);
    }

    while (fgets(linebuf,BUFLEN,file) != NULL) {
        i++;
        if ( (name = (name_rec*)m_malloc(sizeof(name_rec))) == NULL) exit(-1);
        strncpy(name->boy_name,linebuf,BUFLEN);
        HASH_ADD_STR(names,boy_name,name);
    }

    fseek(file,0,SEEK_SET);

    while (fgets(linebuf,BUFLEN,file) != NULL) {
        HASH_FIND_STR(names,linebuf,name);
        if (!name) printf("failed to find: %s", linebuf);
        else j++;
    }
    fclose(file);
    printf("lookup on %d of %d names succeeded\n", j, i);
   
	/* free memory */
	HASH_ITER(hh, names, name, tmp) {
		HASH_DEL(names, name);     /* delete */
		m_free(name);
	}
   
	return 0;
}
