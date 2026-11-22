#ifndef _PRUNE_H
#define _PRUNE_H

#include <adt/p_forward_list_alt.h>

// Data

struct prune
{
   struct prune *next;         // link field needed by p_forward_list
   unsigned char path[1];      // variable size path in canonical form
};

extern p_forward_list_alt_t prune_list;

// Functions

extern void prune_clear_list(void);
extern void prune_add_list(unsigned char *name);
extern unsigned char prune_apply(unsigned char *name);

#endif
