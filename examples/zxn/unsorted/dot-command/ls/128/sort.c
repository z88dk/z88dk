#include <string.h>
#include <libgen.h>
#include <time.h>
#include <arch/zxn.h>

#define NONONO

#include "ls.h"
#include "memory.h"
#include "options.h"
#include "sort.h"

static struct file_record_ptr frp_a;
static struct file_record_ptr frp_b;

static struct file_record *fr_a;
static struct file_record *fr_b;

static int res;

static void sort_common(struct file_record_ptr *a, struct file_record_ptr *b)
{
   // copy to main memory
   
   memcpy(&frp_a, a, sizeof(frp_a));
   memcpy(&frp_b, b, sizeof(frp_b));

   // page in file records
   
   memory_page_in_mmu6(frp_a.page + BASE_LFN_PAGES);
   memory_page_in_mmu7(frp_b.page + BASE_LFN_PAGES);
   
   fr_a = zxn_addr_in_mmu(6, frp_a.fr);
   fr_b = frp_b.fr;

   // directories first
   
   res = 0;
   
   if ((flags.sort_mod & FLAG_SORT_MOD_GDF) && (fr_a->type != fr_b->type))
   {
      // directories first
      // one is a directory and the other isn't
      
      res = (fr_a->type == FILE_RECORD_TYPE_DIR) ? -1 : 1;
   }
   
   return;
}

int sort_cmp_file_by_name(struct file_record_ptr *a, struct file_record_ptr *b)
{
   // common sort operations
   
   sort_common(a, b);

   // compare
   
   if (res == 0)
   {
      res = stricmp(zxn_addr_in_mmu(6, fr_a->lfn), fr_b->lfn);
      
      if (flags.sort_mod & FLAG_SORT_MOD_REVERSE)
         res = -res;
   }

   // restore main memory
   
   memory_restore_dir();
   
   return res;
}

int sort_cmp_file_by_time(struct file_record_ptr *a, struct file_record_ptr *b)
{
   // common sort operations
   
   sort_common(a, b);

   // compare newest first (largest time value)
   
   if (res == 0)
   {
      if ((res = compare_dostm(&fr_b->time, &fr_a->time)) == 0)
         res = stricmp(zxn_addr_in_mmu(6, fr_a->lfn), fr_b->lfn);
      
      if (flags.sort_mod & FLAG_SORT_MOD_REVERSE)
         res = -res;
   }

   // restore main memory
   
   memory_restore_dir();
   
   return res;
}

int sort_cmp_file_by_size(struct file_record_ptr *a, struct file_record_ptr *b)
{
   // common sort operations
   
   sort_common(a, b);

   // compare largest first
   
   if (res == 0)
   {
      if (fr_a->size < fr_b->size)
         res = 1;
      else
      {
         if (fr_a->size == fr_b->size)
            res = stricmp(zxn_addr_in_mmu(6, fr_a->lfn), fr_b->lfn);
         else
            res = -1;
      }

      if (flags.sort_mod & FLAG_SORT_MOD_REVERSE)
         res = -res;
   }

   // restore main memory
   
   memory_restore_dir();
   
   return res;
}

int sort_cmp_file_by_extension(struct file_record_ptr *a, struct file_record_ptr *b)
{
   // common sort operations
   
   sort_common(a, b);

   // compare
   
   if (res == 0)
   {
      if ((res = stricmp(basename_ext(zxn_addr_in_mmu(6, fr_a->lfn)), basename_ext(fr_b->lfn))) == 0)
         res = stricmp(zxn_addr_in_mmu(6, fr_a->lfn), fr_b->lfn);
      
      if (flags.sort_mod & FLAG_SORT_MOD_REVERSE)
         res = -res;
   }

   // restore main memory
   
   memory_restore_dir();
   
   return res;
}

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
