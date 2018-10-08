#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <adt/p_forward_list_alt.h>
#include <alloc/obstack.h>

#include "errors.h"
#include "find.h"
#include "prune.h"

p_forward_list_alt_t prune_list;

void prune_clear_list(void)
{
   p_forward_list_alt_init(&prune_list);
}

void prune_add_list(unsigned char *name)
{
   struct prune *p;

   if ((p = obstack_alloc(ob, sizeof(struct prune) + strlen(name))) == 0)
      exit((int)err_out_of_memory);
   
   strcpy(p->path, name);
   p_forward_list_alt_push_back(&prune_list, p);
}

unsigned char prune_apply(unsigned char *name)
{
   for (struct prune *p = p_forward_list_alt_front(&prune_list); p; p = p_forward_list_alt_next(p))
      if (glob_fat(name, p->path)) return 1;

   return 0;
}
