#include <string.h>

#include "option.h"
#include "run.h"
#include "sort.h"

// file type sorting

int sort_type(struct type *a, struct type *b)
{
   return stricmp(a->extension, b->extension);
}

int find_type(char *extension, struct type *a)
{
   return stricmp(extension, a->extension);
}

// option sorting

int sort_option(struct opt *a, struct opt *b)
{
   return strcmp(a->name, b->name);
}

int find_option(unsigned char *name, struct opt *a)
{
   if (a->type == OPT_TYPE_EXACT)
      return strcmp(name, a->name);
   
   return strncmp(name, a->name, strlen(a->name));
}
