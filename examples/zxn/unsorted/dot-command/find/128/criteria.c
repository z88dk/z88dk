#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <arch/zxn/esxdos.h>
#include <adt/p_forward_list_alt.h>
#include <alloc/obstack.h>

#include "criteria.h"
#include "errors.h"
#include "find.h"

p_forward_list_alt_t criteria_list;

void criteria_clear_list(void)
{
   p_forward_list_alt_init(&criteria_list);
}

void criteria_add_list(unsigned char (*func)(void))
{
   struct criteria *c;
   
   if ((c = obstack_alloc(ob, sizeof(struct criteria))) == 0)
      exit((int)err_out_of_memory);
   
   c->func = (void *)func;
   p_forward_list_alt_push_back(&criteria_list, c);
}

void criteria_add_list_long(unsigned char (*func)(int32_t *), const int32_t *num)
{
   struct criteria *c;
   
   if ((c = obstack_alloc(ob, sizeof(struct criteria) + sizeof(int32_t) - 1)) == 0)
      exit((int)err_out_of_memory);
   
   c->func = (void *)func;
   memcpy(c->data, num, sizeof(int32_t));
   
   p_forward_list_alt_push_back(&criteria_list, c);
}

void criteria_add_list_string(unsigned char (*func)(unsigned char *), const char *s)
{
   struct criteria *c;
   
   if ((c = obstack_alloc(ob, sizeof(struct criteria) + strlen(s))) == 0)
      exit((int)err_out_of_memory);
   
   c->func = (void *)func;
   strcpy(c->data, s);

   p_forward_list_alt_push_back(&criteria_list, c);
}

unsigned char criteria_apply(void)
{
   for (struct criteria *c = p_forward_list_alt_front(&criteria_list); c; c = p_forward_list_alt_next(c))
      if ((c->func)(c->data) == 0) return 0;

   return 1;
}

// criteria functions return non-zero if satisfied

unsigned char criteria_exec(void)
{
   unsigned char *p;
   
   // match file against executables
   // bas, dot, nex, o, p, sna, snx, tap, z80
   
   if (dirent_lfn.attr & ESX_DIR_A_DIR) return 0;
   
   p = basename_ext(dirent_lfn.name);
   
   if ((stricmp(p, ".bas") == 0) ||
       (stricmp(p, ".dot") == 0) ||
       (stricmp(p, ".nex") == 0) ||
       (stricmp(p, ".o") == 0) ||
       (stricmp(p, ".p") == 0) ||
       (stricmp(p, ".sna") == 0) ||
       (stricmp(p, ".snx") == 0) ||
       (stricmp(p, ".tap") == 0) ||
       (stricmp(p, ".z80") == 0))
   return 1;

   return 0;
}

unsigned char criteria_name(unsigned char *pattern)
{
   return glob_fat(dirent_lfn.name, pattern);
}

unsigned char criteria_size(int32_t *multiplier)
{
   struct esx_dirent_slice *slice;
   
   slice = esx_slice_dirent(&dirent_lfn);
   
   if (*multiplier >= 0)
      return (slice->size >= *multiplier);
   
   return (slice->size < -(*multiplier));
}

unsigned char criteria_type_d(void)
{
   return (dirent_lfn.attr & ESX_DIR_A_DIR) != 0;
}

unsigned char criteria_type_f(void)
{
   return (dirent_lfn.attr & ESX_DIR_A_DIR) == 0;
}
