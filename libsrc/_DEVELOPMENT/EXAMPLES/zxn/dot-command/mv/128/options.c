#include <ctype.h>
#include <string.h>
#include <libgen.h>
#include <arch/zxn/esxdos.h>

#include "errors.h"
#include "mv.h"
#include "options.h"

// option arguments

static unsigned char *option_next_arg(unsigned char *idx, int argc, char **argv)
{
   if (++*idx < (unsigned char)argc) return argv[*idx];
   return 0;
}

static unsigned char *option_equal_arg(unsigned char *p)
{
   return strrstrip(strstrip(p));
}

// option exec

unsigned int option_exec_b(void)
{
   flags.backup = 1;
   return OPT_ACTION_OK;
}

unsigned int option_exec_f(void)
{
   flags.overwrite = FLAG_OVERWRITE_YES;
   return OPT_ACTION_OK;
}

unsigned int option_exec_i(void)
{
   flags.overwrite = FLAG_OVERWRITE_ASK;
   return OPT_ACTION_OK;
}

unsigned int option_exec_n(void)
{
   flags.overwrite = FLAG_OVERWRITE_NO;
   return OPT_ACTION_OK;
}

unsigned int option_exec_strip_slashes(void)
{
   flags.slashes = 1;
   return OPT_ACTION_OK;
}

unsigned int option_exec_S_helper(unsigned char *p)
{
   if (p)
   {
      if (*p == '.') ++p;
   
      if (*p && (strlen(p) < 4) && (strpbrk(p, "./\\*?") == 0))
      {
         flags.suffix = p;
         return OPT_ACTION_OK;
      }
   }
   
   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_S(unsigned char *idx, int argc, char **argv)
{
   return option_exec_S_helper(option_next_arg(idx, argc, argv));
}

unsigned int option_exec_suffix(unsigned char *idx, int argc, char **argv)
{
   return option_exec_S_helper(option_equal_arg(argv[*idx] + strlen("--suffix=")));
}

unsigned int option_exec_t_helper(unsigned char *p)
{
   if (p)
   {
      unsigned char *q;
      
      q = advance_past_drive(p);
      
      if (isspace(*q)) return(ESX_EINVAL);
      if (*q) strcpy(q, pathnice(q));
      
      if (*p)
      {
         if (dst.type != FILE_TYPE_UNKNOWN)
            return (unsigned int)err_destination_duplicated;
         
         dst.name = p;
         dst.type = FILE_TYPE_DIRECTORY;
         
         return OPT_ACTION_OK;
      }
   }
   
   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_t(unsigned char *idx, int argc, char **argv)
{
   return option_exec_t_helper(option_next_arg(idx, argc, argv));
}

unsigned int option_exec_target_directory(unsigned char *idx, int argc, char **argv)
{
   return option_exec_t_helper(option_equal_arg(argv[*idx] + strlen("--target-directory=")));
}

unsigned int option_exec_T(void)
{
   if (dst.type != FILE_TYPE_UNKNOWN)
      return (unsigned int)err_destination_duplicated;
   
   dst.type = FILE_TYPE_NORMAL;
   return OPT_ACTION_OK;
}

unsigned int option_exec_u(void)
{
   flags.update = 1;
   return OPT_ACTION_OK;
}

unsigned int option_exec_v(void)
{
   flags.verbose = 1;
   return OPT_ACTION_OK;
}

unsigned int option_exec_help(void)
{
   flags.help = 1;
   return OPT_ACTION_OK;
}

unsigned int option_exec_version(void)
{
   flags.version = 1;
   return OPT_ACTION_OK;
}

unsigned int option_exec_system(void)
{
   flags.system = 1;
   return OPT_ACTION_OK;
}
