#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <errno.h>

#include "date.h"
#include "errors.h"
#include "ls.h"
#include "options.h"
#include "sort.h"

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

unsigned int option_exec_a(void)
{
   flags.file_filter = (flags.file_filter & (~FLAG_FILE_FILTER_ALMOST_ALL)) | FLAG_FILE_FILTER_ALL;
   return OPT_ACTION_OK;
}

unsigned int option_exec_A(void)
{
   flags.file_filter = (flags.file_filter & (~FLAG_FILE_FILTER_ALL)) | FLAG_FILE_FILTER_ALMOST_ALL;
   return OPT_ACTION_OK;
}

unsigned int option_exec_B(void)
{
   flags.file_filter |= FLAG_FILE_FILTER_BACKUP;
   return OPT_ACTION_OK;
}

struct block_size
{
   unsigned char *symbol;
   uint32_t divisor;
};

static struct block_size block_sizes[] = {
   { "K", 1024UL },
   { "M", 1048576UL },
   { "KB", 1000UL },
   { "MB", 1000000UL },
};

unsigned int option_exec_block_size_helper(unsigned char *p)
{
   if (p && *p)
   {
      unsigned int num;
      static unsigned char *endp;
      
      // leading number
      
      flags.size_divisor = 1UL;
      
      errno = 0;
      num = _strtou_(p, &endp, 0);
      
      if (errno == 0)
      {
         flags.size_divisor = num;
         p = endp;
      }
      
      // trailing suffix
      
      for (unsigned char i = 0; i != sizeof(block_sizes) / sizeof(*block_sizes); ++i)
      {
         if (stricmp(block_sizes[i].symbol, p) == 0)
         {
            *p = 0;
            flags.size_divisor *= block_sizes[i].divisor;
            
            break;
         }
      }
      
      // successful ?
      
      if (*p == 0)
         return OPT_ACTION_OK;
   }
   
   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_block_size(unsigned char *idx, int argc, char **argv)
{
   return option_exec_block_size_helper(option_equal_arg(argv[*idx] + strlen("--block-size=")));
}

unsigned int option_exec_h(void)
{
   flags.size_type = FLAG_SIZE_TYPE_HUMAN;
   return OPT_ACTION_OK;
}

unsigned int option_exec_si(void)
{
   flags.size_type = FLAG_SIZE_TYPE_SI;
   return OPT_ACTION_OK;
}

unsigned int option_exec_s(void)
{
   flags.disp_size = 1;
   return OPT_ACTION_OK;
}

unsigned int option_exec_t(void)
{
   flags.sort_func = (void*)sort_cmp_file_by_time;
   return OPT_ACTION_OK;
}

unsigned int option_exec_gdf(void)
{
   flags.sort_mod |= FLAG_SORT_MOD_GDF;
   return OPT_ACTION_OK;
}

unsigned int option_exec_r(void)
{
   flags.sort_mod |= FLAG_SORT_MOD_REVERSE;
   return OPT_ACTION_OK;
}

unsigned int option_exec_S(void)
{
   flags.sort_func = (void*)sort_cmp_file_by_size;
   return OPT_ACTION_OK;
}

unsigned int option_exec_U(void)
{
   flags.sort_func = 0;
   return OPT_ACTION_OK;
}

unsigned int option_exec_X(void)
{
   flags.sort_func = (void*)sort_cmp_file_by_extension;
   return OPT_ACTION_OK;
}

unsigned int option_exec_time_long_iso(void)
{
   flags.date_func = date_fmt_long_iso;
   return OPT_ACTION_OK;
}

unsigned int option_exec_time_iso(void)
{
   flags.date_func = date_fmt_iso;
   return OPT_ACTION_OK;
}

unsigned int option_exec_time_locale(void)
{
   flags.date_func = date_fmt_locale;
   return OPT_ACTION_OK;
}

unsigned int option_exec_color_never(void)
{
   flags.name_fmt_mod &= ~FLAG_NAME_FMT_MOD_COLOR;
   return OPT_ACTION_OK;
}

unsigned int option_exec_color_always(void)
{
   flags.name_fmt_mod |= FLAG_NAME_FMT_MOD_COLOR;
   return OPT_ACTION_OK;
}

unsigned int option_exec_F(void)
{
   flags.name_fmt_classify = FLAG_NAME_FMT_CLASSIFY_ALL;
   return OPT_ACTION_OK;
}

unsigned int option_exec_file_type(void)
{
   flags.name_fmt_classify = FLAG_NAME_FMT_CLASSIFY_ALL & (~FLAG_NAME_FMT_CLASSIFY_EXE);
   return OPT_ACTION_OK;
}

unsigned int option_exec_indicator_style_none(void)
{
   flags.name_fmt_classify = FLAG_NAME_FMT_CLASSIFY_NONE;
   return OPT_ACTION_OK;
}

unsigned int option_exec_p(void)
{
   flags.name_fmt_classify = FLAG_NAME_FMT_CLASSIFY_DIR;
   return OPT_ACTION_OK;
}

unsigned int option_exec_Q(void)
{
   flags.name_fmt_mod |= FLAG_NAME_FMT_MOD_QUOTE;
   return OPT_ACTION_OK;
}

unsigned int option_exec_C(void)
{
   flags.disp_fmt = FLAG_DISP_FMT_COLUMN;
   return OPT_ACTION_OK;
}

unsigned int option_exec_x(void)
{
   flags.disp_fmt = FLAG_DISP_FMT_ACROSS;
   return OPT_ACTION_OK;
}

unsigned int option_exec_m(void)
{
   flags.disp_fmt = FLAG_DISP_FMT_COMMAS;
   return OPT_ACTION_OK;
}

unsigned int option_exec_l(void)
{
   flags.disp_fmt = FLAG_DISP_FMT_LONG;
   return OPT_ACTION_OK;
}

unsigned int option_exec_one(void)
{
   flags.disp_fmt = FLAG_DISP_FMT_PER_LINE;
   return OPT_ACTION_OK;
}

unsigned int option_exec_w_helper(unsigned char *p)
{
   if (p)
   {
      unsigned int res;
      static unsigned char *endp;
      
      errno = 0;
      res = _strtou_(p, &endp, 0);
      
      if ((errno == 0) && (*endp == 0) && (res < 256))    // there is a -1 option so eliminate negative values
      {
         flags.disp_width = res;
         return OPT_ACTION_OK;
      }
   }
   
   return (unsigned int)err_invalid_parameter;
}

unsigned int option_exec_w(unsigned char *idx, int argc, char **argv)
{
   return option_exec_w_helper(option_next_arg(idx, argc, argv));
}

unsigned int option_exec_width(unsigned char *idx, int argc, char **argv)
{
   return option_exec_w_helper(option_equal_arg(argv[*idx] + strlen("--width=")));
}

unsigned int option_exec_d(void)
{
   flags.dir_type = FLAG_DIR_TYPE_LIST;
   return OPT_ACTION_OK;
}

unsigned int option_exec_R(void)
{
   flags.dir_type = FLAG_DIR_TYPE_RECURSIVE;
   return OPT_ACTION_OK;
}

unsigned int option_exec_system(void)
{
   flags.sys = 1;
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

unsigned int option_exec_lfn_on(void)
{
   flags.name_fmt_mod = (flags.name_fmt_mod & ~(FLAG_NAME_FMT_MOD_SFN | FLAG_NAME_FMT_MOD_LFN | FLAG_NAME_FMT_MOD_AUTO)) | FLAG_NAME_FMT_MOD_LFN;
   return OPT_ACTION_OK;
}

unsigned int option_exec_lfn_off(void)
{
   flags.name_fmt_mod = (flags.name_fmt_mod & ~(FLAG_NAME_FMT_MOD_SFN | FLAG_NAME_FMT_MOD_LFN | FLAG_NAME_FMT_MOD_AUTO)) | FLAG_NAME_FMT_MOD_SFN;
   return OPT_ACTION_OK;
}

unsigned int option_exec_lfn_both(void)
{
   flags.name_fmt_mod = (flags.name_fmt_mod & ~(FLAG_NAME_FMT_MOD_SFN | FLAG_NAME_FMT_MOD_LFN | FLAG_NAME_FMT_MOD_AUTO)) | FLAG_NAME_FMT_MOD_SFN | FLAG_NAME_FMT_MOD_LFN;
   return OPT_ACTION_OK;
}
