#include <stdio.h>
#include <string.h>
#include <libgen.h>
#include <arch/zxn/esxdos.h>
#include <alloc/obstack.h>
#include <adt/p_queue.h>

#include "catalog.h"
#include "list.h"
#include "ls.h"
#include "memory.h"
#include "user_interaction.h"

unsigned char catalog_control;
unsigned char catalog_morethanone;

// lfn & catalog must be available to NextZXOS +3e api
// which means they must lie inside [0x4000,0xbfe0)

struct esx_lfn lfn;
struct esx_cat catalog;


static struct dir_record *first;

void catalog_add_dir_record(unsigned char *name)
{
   int size;

   static struct dir_record *last;
   static struct dir_record *next;
   static struct dir_record *spot;
   
   // name is in main bank
   
   // page in directory bank
   
   memory_page_in_dir(BASE_DIR_PAGES);
   
   // compute size of directory entry needed
   // (space for zero terminator built into struct dir_record)
   
   size = strlen(name) + sizeof(struct dir_record);
   
   // allocate a spot in directory queue if we can
   
   spot = 0;
   
   if ((first = p_queue_front(&dqueue)) == 0)
   {
      // the directory queue is empty
      // assume one directory entry will always fit
      
      spot = (struct dir_record *)dir_start;
   }
   else
   {
      // the directory queue is not empty
      
      last = p_queue_back(&dqueue);
      next = (struct dir_record *)((unsigned char *)last + last->size);
      
      if (first <= last)
      {         
         if ((next >= last) && (((unsigned char *)dir_end - (unsigned char *)next) >= size))
            spot = next;
      }
      
      if (spot == 0)
      {
         if (first <= last)
         {
            next = (struct dir_record *)dir_start;
            last = next;
         }
         
         if ((next >= last) && (((unsigned char *)first - (unsigned char *)next) >= size))
            spot = next;
      }
   }

   // insert into directory queue
   
   if (spot)
   {
      spot->size = size;
      strcpy(spot->name, name);
      
      p_queue_push(&dqueue, spot);
   }
   else
      printf(" \nskipped dir %s\n", name);

   // restore main bank
   
   memory_restore_dir();

   return;
}

static struct file_record_ptr frp;
static struct file_record fr;

static unsigned char *cat_lfn_name;

unsigned char catalog_add_file_record(void)
{
   static unsigned int size;
   
   size = strlen(cat_lfn_name) + sizeof(fr);
   
   // locate memory to store file record
   
   {
      unsigned char i;
      
      for (i = 0; i != NUM_LFN_PAGES; ++i)
      {
         memory_page_in_mmu7(clob + BASE_LFN_PAGES);
      
         if (frp.fr = obstack_alloc(lob[clob], size))
            break;
      
         if (++clob >= NUM_LFN_PAGES)
            clob = 0;
      }
   
      if (i == NUM_LFN_PAGES) return 1;
   }
   
   frp.page = clob;
   
   // complete fr
   
   fr.len = 0;
   
   if (flags.name_fmt_mod & FLAG_NAME_FMT_MOD_LFN)
      fr.len = size - sizeof(fr);
   
   if (flags.name_fmt_mod & FLAG_NAME_FMT_MOD_SFN)
      fr.len += 12;
   
   if (flags.name_fmt_mod & (FLAG_NAME_FMT_MOD_LFN | FLAG_NAME_FMT_MOD_SFN))
      fr.len += 2;
   
   // copy completed file record to obstack
   
   memcpy(frp.fr, &fr, sizeof(fr));
   memcpy(frp.fr->lfn, cat_lfn_name, size - sizeof(fr) + 1);

   // restore memory
   
   memory_restore_mmu7();
   
   // add file record pointer
   
   if (obstack_copy(fob, &frp, sizeof(frp)))
   {
      ++fbase_sz;
      return 0;
   }
   
   return 1;
}

static unsigned char name_in_main_memory[ESX_FILENAME_LFN_MAX*2 + 1];
static unsigned char constructed_name[ESX_FILENAME_LFN_MAX*2 + 1];

void catalog_add_file_records(unsigned char *name)
{
   unsigned char another;
      
   static unsigned char morethanone;
   static unsigned char enter_dir;
   static unsigned char dots;
   static unsigned char filter;
   
   static unsigned char *constructed_name_base;

   // opportunity for user to break
   
   user_interaction_spin();

   // name is visible and could be in divmmc or dir bank
   // main bank is restored in mmu6,7 by this function
   
   strcpy(name_in_main_memory, name);

   // name_in_main_memory must remain unaltered while matching
   // so a copy is made where directory names can be constructed

   strcpy(constructed_name, name_in_main_memory);
   
   constructed_name_base = advance_past_drive(constructed_name);
   if (*constructed_name_base) constructed_name_base = basename(constructed_name_base);

   // restore mmu6,7
   
   memory_restore_dir();
   
   // init catalog structure for matching
   
   catalog.filter = (flags.sys) ? (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN | ESX_CAT_FILTER_DIR) : (ESX_CAT_FILTER_LFN | ESX_CAT_FILTER_DIR);
   catalog.filename = p3dos_cstr_to_pstr(name_in_main_memory);
   catalog.cat_sz = 2;
   
   lfn.cat = &catalog;
   cat_lfn_name = lfn.filename;
   
   // iterate over all matches
   
   if (esx_dos_catalog(&catalog) == 1)
   {
      enter_dir = (catalog_control == CATALOG_MODE_SRC) && (flags.dir_type != FLAG_DIR_TYPE_LIST);

      do
      {
         // opportunity for user to break
         
         user_interaction_spin();

         // lfn details for this file

         esx_ide_get_lfn(&lfn, &catalog.cat[1]);

         // fill in matched file details
         
         fr.type = (catalog.cat[1].filename[7] & 0x80) ? FILE_RECORD_TYPE_DIR : FILE_RECORD_TYPE_FILE;
         memcpy(&fr.time, &lfn.time, sizeof(fr.time) + sizeof(fr.size));
         p3dos_dosname_from_catname(fr.sfn, catalog.cat[1].filename);

         // find out if there is another match
         
         another = (esx_dos_catalog_next(&catalog) == 1);

         // filter listed files

         dots = (strcmp(fr.sfn, ".") == 0) || (strcmp(fr.sfn, "..") == 0);
         
         if ((filter = dots && (flags.file_filter & FLAG_FILE_FILTER_ALMOST_ALL)) == 0)
            filter = (flags.file_filter & FLAG_FILE_FILTER_BACKUP) && (stricmp(basename_ext(fr.sfn), ".bak") == 0);
         
         if (filter == 0)
         {
            // indicate if there is more than one match

            catalog_morethanone |= another;

            // if there's one match and it's a directory we may want to enter the directory instead of listing it
         
            if ((enter_dir == 0) || (fr.type != FILE_RECORD_TYPE_DIR) || catalog_morethanone)
            {
               // file is part of list
            
               if (catalog_add_file_record())
               {
                  // out of memory for records so must list partially complete directory
               
                  list_generate();
                  memory_clear_file_records();
               
                  // now add record
               
                  catalog_add_file_record();
               }
            }
         
            // determine if we're adding directory to queue
         
            if ((fr.type == FILE_RECORD_TYPE_DIR) && (dots == 0) && ((flags.dir_type == FLAG_DIR_TYPE_RECURSIVE) || (enter_dir && (catalog_morethanone == 0))))
            {
               // construct name

               strcat(strcpy(constructed_name_base, fr.sfn), "/");

               // add directory to queue

               catalog_add_dir_record(constructed_name);
            }
         }
      }
      while (another == 1);
   }
   
   return;
}

static struct esx_dirent dirent_sfn;
static struct esx_dirent_lfn dirent_lfn;

static struct esx_dirent_slice *slice;

void catalog_add_file_records_from_dir(unsigned char *name)
{
   static unsigned char dots;
   static unsigned char filter;
   
   static unsigned char *constructed_name_base;
   
   // read directory contents directly

   // copy directory name so that it can be modified to create new directories
   
   strcpy(constructed_name, name);
   constructed_name_base = constructed_name + strlen(constructed_name);
   
   // gathering both sfn and lfn names can be done by
   // opening the dir twice, once in sfn mod and once in lfn mode

   fin = esx_f_opendir_ex(name, ESX_DIR_USE_LFN);
   gin = esx_f_opendir(name);
   
   if ((fin == 0xff) || (gin == 0xff))
   {
      printf(" \nbad dirname %s\n", name);
   }
   else
   {
      cat_lfn_name = dirent_lfn.name;

      while ((esx_f_readdir(fin, &dirent_lfn) == 1) && (esx_f_readdir(gin, &dirent_sfn) == 1))
      {
         // opportunity for user to break
         
         user_interaction_spin();

         // filter entry

         dots = (strcmp(dirent_sfn.name, ".") == 0) || (strcmp(dirent_sfn.name, "..") == 0);
         
         if ((filter = dots && (flags.file_filter & FLAG_FILE_FILTER_ALMOST_ALL)) == 0)
            if ((filter = (flags.sys == 0) && (dirent_sfn.attr & ESX_DIR_A_SYS)) == 0)
               filter = (flags.file_filter & FLAG_FILE_FILTER_BACKUP) && (stricmp(basename_ext(dirent_sfn.name), ".bak") == 0);

         // create file record
         
         if (filter == 0)
         {
            // fill in file record

            slice = esx_slice_dirent(&dirent_sfn);
         
            fr.type = (dirent_sfn.attr & ESX_DIR_A_DIR) ? FILE_RECORD_TYPE_DIR : FILE_RECORD_TYPE_FILE;
            memcpy(&fr.time, &slice->time, sizeof(fr.time) + sizeof(fr.size));
            strcpy(fr.sfn, dirent_sfn.name);
            
            // add file record

            if (catalog_add_file_record())
            {
               // out of memory for records so must list partially complete directory
               
               list_generate();
               memory_clear_file_records();
               
               // now add record
               
               catalog_add_file_record();
            }

            // determine if we're adding to the directory queue
            
            if ((fr.type == FILE_RECORD_TYPE_DIR) && (dots == 0) && (flags.dir_type == FLAG_DIR_TYPE_RECURSIVE))
            {
               // construct name

               strcat(strcpy(constructed_name_base, dirent_sfn.name), "/");

               // add directory to queue

               catalog_add_dir_record(constructed_name);
            }
         }
      }
   }
   
   close_open_files();
   return;
}
