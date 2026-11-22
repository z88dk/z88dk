#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <libgen.h>
#include <errno.h>
#include <arch/zxn/esxdos.h>

#include "criteria.h"
#include "errors.h"
#include "find.h"
#include "options.h"
#include "prune.h"

// option sort

int sort_cmp_option(struct opt *a, struct opt *b)
{
   return strcmp(a->name, b->name);
}

int sort_opt_search(unsigned char *name, struct opt *a)
{
   if (a->type == OPT_TYPE_EXACT)
      return strcmp(name, a->name);
   
   return strncmp(name, a->name, strlen(a->name));
}

// option arguments 

static unsigned char *option_next_arg(unsigned char *idx, unsigned int argc, char **argv)
{
   if (++*idx < (unsigned char)argc) return strrstrip(strstrip(argv[*idx]));
   return 0;
}

static unsigned char *option_equal_arg(unsigned char *p)
{
   return strrstrip(strstrip(p));
}

static unsigned char *endp;

static unsigned char option_signed_number(unsigned char *p, int *res)
{
   if (p && *p)
   {
      int num;

      errno = 0;
      num = _strtoi_(p, &endp, 0);
      
      if ((errno == 0) && (*endp == 0))
      {
         *res = num;
         return 1;
      }
   }
   
   return 0;
}

static unsigned char option_unsigned_number(unsigned char *p, unsigned int *res)
{
   if (p && *p)
   {
      unsigned int num;

      errno = 0;
      num = _strtou_(p, &endp, 0);
      
      if ((errno == 0) && (*endp == 0))
      {
         *res = num;
         return 1;
      }
   }
   
   return 0;
}

// options

// name

unsigned int option_exec_name_helper(unsigned char *p)
{
   if (p && *p)
   {
      criteria_add_list_string(criteria_name, p);
      return OPT_ACTION_OK;
   }
   
   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_name(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_name_helper(option_next_arg(i, argc, argv));
}

unsigned int option_exec_name_eq(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_name_helper(option_equal_arg(argv[*i] + strlen("-name=")));
}

// mindepth

unsigned int option_exec_mindepth_helper(unsigned char *p)
{
   unsigned int res;
   
   if ((option_unsigned_number(p, &res)) && (res < 256))
   {
      flags.mindepth = res;
      return OPT_ACTION_OK;
   }

   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_mindepth(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_mindepth_helper(option_next_arg(i, argc, argv));
}

unsigned int option_exec_mindepth_eq(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_mindepth_helper(option_equal_arg(argv[*i] + strlen("-mindepth=")));
}

// maxdepth

unsigned int option_exec_maxdepth_helper(unsigned char *p)
{
   unsigned int res;
   
   if ((option_unsigned_number(p, &res)) && (res < 256))
   {
      flags.maxdepth = res;
      return OPT_ACTION_OK;
   }

   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_maxdepth(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_maxdepth_helper(option_next_arg(i, argc, argv));
}

unsigned int option_exec_maxdepth_eq(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_maxdepth_helper(option_equal_arg(argv[*i] + strlen("-maxdepth=")));
}

// type

unsigned int option_exec_type(unsigned char *i, unsigned int argc, char **argv)
{
   unsigned char *p;

   if (p = option_next_arg(i, argc, argv))
   {
      if (stricmp(p, "d") == 0) return option_exec_type_d();
      if (stricmp(p, "f") == 0) return option_exec_type_f();
   }
   
   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_type_d(void)
{
   criteria_add_list(criteria_type_d);
   return OPT_ACTION_OK;
}

unsigned int option_exec_type_f(void)
{
   criteria_add_list(criteria_type_f);
   return OPT_ACTION_OK;
}

// size

struct block_size
{
   unsigned char *symbol;
   int32_t multiplier;
};

static struct block_size block_sizes[] = {
   { "b", 512L },
   { "c", 1L },
   { "w", 2L },
   { "k", 1024L },
   { "M", 1048576L }
};

unsigned int option_exec_size_helper(unsigned char *p)
{
   if (p && *p)
   {
      static int32_t num;
      static int32_t multiplier;

      errno = 0;
      num = strtol(p, &endp, 0);
      
      if (errno == 0)
      {
         multiplier = 1;
         
         for (unsigned char i = 0; i != sizeof(block_sizes) / sizeof(*block_sizes); ++i)
         {
            if (stricmp(block_sizes[i].symbol, endp) == 0)
            {
               *endp = 0;
               multiplier = block_sizes[i].multiplier;

               break;
            }
         }

         if (*endp == 0)
         {
            num *= multiplier;
            criteria_add_list_long(criteria_size, &num);

            return OPT_ACTION_OK;
         }
      }
   }
   
   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_size(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_size_helper(option_next_arg(i, argc, argv));
}

unsigned int option_exec_size_eq(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_size_helper(option_equal_arg(argv[*i] + strlen("-size=")));
}

// mtime

unsigned int option_exec_mtime_helper(unsigned char *p)
{
   // time.h not complete enough yet
   
   int res;
   
   if (option_signed_number(p, &res))
   {
      // ...
      return OPT_ACTION_OK;
   }

// return (unsigned int)err_invalid_parameter;
   return OPT_ACTION_OK;
}

unsigned int option_exec_mtime(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_mtime_helper(option_next_arg(i, argc, argv));
}

unsigned int option_exec_mtime_eq(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_mtime_helper(option_equal_arg(argv[*i] + strlen("-mtime=")));
}

// mmin

unsigned int option_exec_mmin_helper(unsigned char *p)
{
   // time.h not complete enough yet
   
   int res;
   
   if (option_signed_number(p, &res))
   {
      // ...
      return OPT_ACTION_OK;
   }

// return (unsigned int)err_invalid_parameter;
   return OPT_ACTION_OK;
}

unsigned int option_exec_mmin(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_mmin_helper(option_next_arg(i, argc, argv));
}

unsigned int option_exec_mmin_eq(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_mmin_helper(option_equal_arg(argv[*i] + strlen("-mmin=")));
}

// exec

unsigned int option_exec_exec(void)
{
   criteria_add_list(criteria_exec);
   return OPT_ACTION_OK;
}

// prune

unsigned int option_exec_prune_helper(unsigned char *p)
{
   static unsigned char dirnam[ESX_PATHNAME_MAX + 1];
   
   if (p && *p)
   {
      strcpy(dirnam, p);
      
      if ((strchr(dirnam, '*') == 0) && (strchr(dirnam, '?') == 0))
      {
         unsigned char *q;
         
         // no wildcards so treat this is a canonical path
         
         q = advance_past_drive(dirnam);
         if (*q) strcpy(q, pathnice(q));
         if (*q && strcmp(q, "/")) strcat(q, "/");
         
         if (esx_f_get_canonical_path(dirnam, dirnam))
            return ESX_EPATH;
      }
      
      prune_add_list(dirnam);
      return OPT_ACTION_OK;
   }
   
   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_prune(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_prune_helper(option_next_arg(i, argc, argv));
}

unsigned int option_exec_prune_eq(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_prune_helper(option_equal_arg(argv[*i] + strlen("-prune=")));
}

// lfn

unsigned int option_exec_lfn_on(void)
{
   flags.lfn = FLAG_LFN_ON;
   return OPT_ACTION_OK;
}

unsigned int option_exec_lfn_off(void)
{
   flags.lfn = FLAG_LFN_OFF;
   return OPT_ACTION_OK;
}

unsigned int option_exec_lfn_both(void)
{
   flags.lfn = FLAG_LFN_BOTH;
   return OPT_ACTION_OK;
}

// cd

unsigned int option_exec_cd_helper(unsigned char *p)
{
   unsigned int res;
   
   if (option_unsigned_number(p, &res))
   {
      flags.cd = res;
      return OPT_ACTION_OK;
   }

   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_cd(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_cd_helper(option_next_arg(i, argc, argv));
}

unsigned int option_exec_cd_eq(unsigned char *i, unsigned int argc, char **argv)
{
   return option_exec_cd_helper(option_equal_arg(argv[*i] + strlen("-cd=")));
}

// help

unsigned int option_exec_help(void)
{
   flags.help = 1;
   return OPT_ACTION_OK;
}

// version

unsigned int option_exec_version(void)
{
   flags.version = 1;
   return OPT_ACTION_OK;
}
