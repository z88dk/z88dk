
#include <stdlib.h>

#include "farmalloc.h"



void mallinfo_far(unsigned long *total, unsigned long *largest)
{
    unsigned long tot = 0;
    unsigned long biggest = 0;
	header_t *__far * __far f;
    header_t *__far h;

    for(h = __far_heap, f = &__far_heap; h; f = &(h->next_free), h = h->next_free) {
        size_t blocksize = (char * __far)(h->next) - (char *__far)h;

        tot += blocksize;

        if ( blocksize > biggest ) biggest = blocksize;
    }
    *total = tot;
    *largest = biggest;
}

