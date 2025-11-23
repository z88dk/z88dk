#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <arch/zxn/esxdos.h>

#include "list.h"
#include "ls.h"
#include "memory.h"
#include "sort.h"

#include <intrinsic.h>

static struct file_record_ptr frp;
static unsigned char canonical_cwd[ESX_FILENAME_LFN_MAX + 1];


static unsigned char *list_dirname(void)
{
   unsigned char *cwd, *active;

   cwd = &canonical_cwd[1];
   active = &canonical_active[1];

   while (*cwd && (*++cwd == *++active)) ;

   return active;
}

static unsigned int max(unsigned int a, unsigned int b)
{
   return (a > b) ? a : b;
}

static unsigned int min(unsigned int a, unsigned int b)
{
   return (a < b) ? a : b;
}

void list_generate(void)
{
   static unsigned int i;
   
   if (fbase_sz)
   {
      unsigned char *p;
      
      puts(" ");

      // first find the cwd for the drive the listing comes from
      
      esx_f_getcwd_drive(p3dos_edrv_from_pdrv(get_drive(canonical_active)), canonical_cwd);
      strlwr(canonical_cwd);
      
      // find out what portion of the listing's dir needs to be printed
      // by eliminating the leading part in common with the drive's cwd
      
      if ((*(p = list_dirname())) || (current_drive[0] != canonical_active[0]))
      {
         if (current_drive[0] != canonical_active[0])
            printf("%c:", canonical_active[0]);
         
         puts(p);
      }
      
      // format parameters & sorting

/*
      if (flags.sort_func)
      {
         // we need to sort first in alphabetical order to eliminate duplicate entries caused by
         // merging wildcard src from the same directory into the same listing "ls m*.* b*.*"
         
         qsort(fbase, fbase_sz, sizeof(struct file_record_ptr), sort_cmp_file_by_name);
      }
   
      maxlen_name = 0;
      maxlen_date = 0;
      maxlen_size = 0;
      
      i = fbase_sz;
      
      for (struct file_record_ptr *p = fbase; i--; ++p)
      {
         // copy file record pointer to main memory so it remains visible
            
         memcpy(&frp, p, sizeof(frp));
            
         // place page containing file record into mmu7
            
         memory_page_in_mmu7(frp.page + BASE_LFN_PAGES);
         
         // TODO: eliminate duplicates
         
         // gather format parameters
            
         // restore main memory paging state
            
         memory_restore_mmu7();
      }
*/
      // now sort according to user's criteria
         
//      if (flags.sort_func != sort_cmp_file_by_name)

        if (flags.sort_func)
            qsort(fbase, fbase_sz, sizeof(struct file_record_ptr), flags.sort_func);

      // print out the listing

      printf("total %u files\n\n", fbase_sz);
      
      i = fbase_sz;
         
      for (struct file_record_ptr *p = fbase; i--; ++p)
      {
         static unsigned char *name;
         static unsigned char *ext;
         
         // copy file record pointer to main memory so it remains visible
            
         memcpy(&frp, p, sizeof(frp));
            
         // place page containing file record into mmu7
            
         memory_page_in_mmu7(frp.page + BASE_LFN_PAGES);
            
         // print one line of listing

         name = (flags.name_fmt_mod & FLAG_NAME_FMT_MOD_SFN) ? frp.fr->sfn : frp.fr->lfn;
         ext = basename_ext(name);

         if (frp.fr->type == FILE_RECORD_TYPE_FILE)
         {
            printf("%-11s %6lu %.*s%s\n", flags.date_func(&frp.fr->time), frp.fr->size, min(flags.disp_width - 20 - strlen(ext), ext - name), name, ext);
         }
         else
         {
            printf("%-11s %6s %.*s%s\n", flags.date_func(&frp.fr->time), "", min(flags.disp_width - 20 - strlen(ext), ext - name), name, ext);
         }
            
         // restore main memory paging state
            
         memory_restore_mmu7();
      }
   }

   return;
}
