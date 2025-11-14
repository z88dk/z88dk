#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stddef.h>
#include <ctype.h>
#include <libgen.h>
#include <time.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>
#include <alloc/obstack.h>
#include <adt/p_forward_list.h>
#include <compress/zx7.h>
#include <errno.h>

#include "catalog.h"
#include "date.h"
#include "errors.h"
#include "list.h"
#include "ls.h"
#include "ls-help.h"
#include "memory.h"
#include "options.h"
#include "sort.h"
#include "user_interaction.h"


// SYSTEM INFORMATION

uint8_t current_month;         // tm_mon
int16_t current_year;          // tm_year

struct esx_mode screen_mode;
unsigned char canonical_active[ESX_FILENAME_LFN_MAX + 1];


// ENVIRONMENT VARIABLES

#define LS_COLOR    "LS_COLOR"
#define TIME_STYLE  "TIME_STYLE"


// SELECTED OPTIONS

struct flag flags = {
   FLAG_FILE_FILTER_DOT,       // file_filter : def list all except .*
   FLAG_SIZE_TYPE_NONE,        // size_type : def size printed in bytes
   1UL,                        // size_divisor
   FLAG_SORT_MOD_NONE,         // sort_mod
   (void*)sort_cmp_file_by_name,      // sort_func : def alphabetic listing
   date_fmt_iso,               // date_func : def "2002-03-30" or "03-30 23:45"
   FLAG_NAME_FMT_MOD_SFN,      // name_fmt_mod : use sfn names
   FLAG_NAME_FMT_CLASSIFY_NONE,  // name_fmt_classify : def no trailing chars on filenames
   0,                          // disp_size : no size information in short listings
   0,                          // disp_width : use screen width
   FLAG_DISP_FMT_COLUMN,       // disp_fmt : default listing is columns
   1,                          // sys : always list system files - this makes "--system" obsolete
   FLAG_DIR_TYPE_ENTER,        // dir_type : directories on command line are entered to list contents
   0,                          // help
   0                           // version
};


// ACCEPTED OPTIONS

static struct opt options[] = {
   { "-a", OPT_TYPE_EXACT, (optfunc_t)option_exec_a },
   { "--all", OPT_TYPE_EXACT, (optfunc_t)option_exec_a },
   { "-A", OPT_TYPE_EXACT, (optfunc_t)option_exec_A },
   { "--almost-all", OPT_TYPE_EXACT, (optfunc_t)option_exec_A },
   { "-B", OPT_TYPE_EXACT, (optfunc_t)option_exec_B },
   { "--ignore-backups", OPT_TYPE_EXACT, (optfunc_t)option_exec_B },
   { "--block-size=", OPT_TYPE_LEADING, (optfunc_t)option_exec_block_size },
   { "-h", OPT_TYPE_EXACT, (optfunc_t)option_exec_h },
   { "--human-readable", OPT_TYPE_EXACT, (optfunc_t)option_exec_h },
   { "--si", OPT_TYPE_EXACT, (optfunc_t)option_exec_si },
   { "-s", OPT_TYPE_EXACT, (optfunc_t)option_exec_s },
   { "--size", OPT_TYPE_EXACT, (optfunc_t)option_exec_s },
   {"-t", OPT_TYPE_EXACT, (optfunc_t)option_exec_t },
   { "--gdf", OPT_TYPE_EXACT, (optfunc_t)option_exec_gdf },
   { "--group-directories-first", OPT_TYPE_EXACT, (optfunc_t)option_exec_gdf },
   { "-r", OPT_TYPE_EXACT, (optfunc_t)option_exec_r },
   { "--reverse", OPT_TYPE_EXACT, (optfunc_t)option_exec_r },
   { "-S", OPT_TYPE_EXACT, (optfunc_t)option_exec_S },
   { "--sort=none", OPT_TYPE_EXACT, (optfunc_t)option_exec_U },
   { "--sort=size", OPT_TYPE_EXACT, (optfunc_t)option_exec_S },
   { "--sort=time", OPT_TYPE_EXACT, (optfunc_t)option_exec_t },
   { "--sort=extension", OPT_TYPE_EXACT, (optfunc_t)option_exec_X },
   { "-U", OPT_TYPE_EXACT, (optfunc_t)option_exec_U },
   { "-X", OPT_TYPE_EXACT, (optfunc_t)option_exec_X },
   { "--time-style=long-iso", OPT_TYPE_EXACT, (optfunc_t)option_exec_time_long_iso },
   { "--time-style=iso", OPT_TYPE_EXACT, (optfunc_t)option_exec_time_iso },
   { "--time-style=locale", OPT_TYPE_EXACT, (optfunc_t)option_exec_time_locale },
   { "--color=never", OPT_TYPE_EXACT, (optfunc_t)option_exec_color_never },
   { "--color=always", OPT_TYPE_EXACT, (optfunc_t)option_exec_color_always },
   { "--color=auto", OPT_TYPE_EXACT, (optfunc_t)option_exec_color_always },
   { "--colour=never", OPT_TYPE_EXACT, (optfunc_t)option_exec_color_never },
   { "--colour=always", OPT_TYPE_EXACT, (optfunc_t)option_exec_color_always },
   { "--colour=auto", OPT_TYPE_EXACT, (optfunc_t)option_exec_color_always },
   { "-F", OPT_TYPE_EXACT, (optfunc_t)option_exec_F },
   { "--classify", OPT_TYPE_EXACT, (optfunc_t)option_exec_F },
   { "--file-type", OPT_TYPE_EXACT, (optfunc_t)option_exec_file_type },
   { "--indicator-style=none", OPT_TYPE_EXACT, (optfunc_t)option_exec_indicator_style_none },
   { "--indicator-style=slash", OPT_TYPE_EXACT, (optfunc_t)option_exec_p },
   { "--indicator-style=file-type", OPT_TYPE_EXACT, (optfunc_t)option_exec_file_type },
   { "--indicator-style=classify", OPT_TYPE_EXACT, (optfunc_t)option_exec_F },
   { "-p", OPT_TYPE_EXACT, (optfunc_t)option_exec_p },
   { "-Q", OPT_TYPE_EXACT, (optfunc_t)option_exec_Q },
   { "--quote-name", OPT_TYPE_EXACT, (optfunc_t)option_exec_Q },
   { "-C", OPT_TYPE_EXACT, (optfunc_t)option_exec_C },
   { "--format=across", OPT_TYPE_EXACT, (optfunc_t)option_exec_x },
   { "--format=commas", OPT_TYPE_EXACT, (optfunc_t)option_exec_m },
   { "--format=horizontal", OPT_TYPE_EXACT, (optfunc_t)option_exec_x },
   { "--format=long", OPT_TYPE_EXACT, (optfunc_t)option_exec_l },
   { "--format=single-column", OPT_TYPE_EXACT, (optfunc_t)option_exec_one },
   { "--format=verbose", OPT_TYPE_EXACT, (optfunc_t)option_exec_l },
   { "--format=vertical", OPT_TYPE_EXACT, (optfunc_t)option_exec_C },
   { "-l", OPT_TYPE_EXACT, (optfunc_t)option_exec_l },
   { "-m", OPT_TYPE_EXACT, (optfunc_t)option_exec_m },
   { "-w", OPT_TYPE_EXACT, (optfunc_t)option_exec_w },
   { "--width=", OPT_TYPE_LEADING, (optfunc_t)option_exec_width },
   { "-x", OPT_TYPE_EXACT, (optfunc_t)option_exec_x },
   { "-1", OPT_TYPE_EXACT, (optfunc_t)option_exec_one },
   { "-d", OPT_TYPE_EXACT, (optfunc_t)option_exec_d },
   { "--directory", OPT_TYPE_EXACT, (optfunc_t)option_exec_d },
   { "-R", OPT_TYPE_EXACT, (optfunc_t)option_exec_R },
   { "--recursive", OPT_TYPE_EXACT, (optfunc_t)option_exec_R },
   { "--system", OPT_TYPE_EXACT, (optfunc_t)option_exec_system },
   { "--help", OPT_TYPE_EXACT, (optfunc_t)option_exec_help },
   { "--version", OPT_TYPE_EXACT, (optfunc_t)option_exec_version },
   { "--lfn=on", OPT_TYPE_EXACT, (optfunc_t)option_exec_lfn_on },
   { "--lfn=off", OPT_TYPE_EXACT, (optfunc_t)option_exec_lfn_off },
   { "--lfn=both", OPT_TYPE_EXACT, (optfunc_t)option_exec_lfn_both }
};


// MAIN

struct file
{
   void *next;                 // next ls group
   void *peer;                 // next match in same ls group
   
   char *name;                 // filename to match
   char *canonical_path;
};

static p_forward_list_t src;   // singly-linked list of source files on command line
static struct file *ptr;
static struct file *current;

static unsigned char *getpath(unsigned char *name)
{
   unsigned char *p;
   
   if (esx_f_get_canonical_path(name, lfn.filename))
      exit(ESX_EPATH);
   
   if ((p = obstack_copy(fob, lfn.filename, strlen(lfn.filename) + 1)) == 0)
      exit((int)err_out_of_memory);
   
   return strlwr(p);
}

unsigned char *advance_past_drive(unsigned char *p)
{
   return (isalpha(p[0]) && (p[1] == ':')) ? (p + 2) : p;
}

unsigned char current_drive[] = "c:";

unsigned char get_drive(unsigned char *p)
{
   return (isalpha(p[0]) && (p[1] == ':')) ? p[0] : current_drive[0];
}

void parse_ls_color(unsigned char *s)
{
   return;
}

unsigned char fin = 0xff;
unsigned char gin = 0xff;

void close_open_files(void)
{
   if (fin != 0xff) esx_f_close(fin);
   if (gin != 0xff) esx_f_close(gin);

   fin = gin = 0xff;
}

static unsigned char old_cpu_speed;

static void cleanup(void)
{
   close_open_files();   
   printf(" ");                     // erase any cursor left behind
   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
}

extern unsigned char _ENV_FNAME[];  // environment variables filename

// visit the directory cache

static void process_directory_cache(void)
{
   static struct dir_record *dr;

   // inform catalog routine that dir is being catalogued

   catalog_control = CATALOG_MODE_DIR;

   memory_clear_file_records();

   for (memory_page_in_dir(BASE_DIR_PAGES); dr = p_queue_pop(&dqueue); memory_page_in_dir(BASE_DIR_PAGES))
   {
      // opportunity for user to break
         
      user_interaction_spin();

      //
      
      if (esx_f_get_canonical_path(dr->name, canonical_active))
         printf(" \nignoring invalid path:\n%s\n", dr->name);
      else
      {
         strlwr(canonical_active);

         catalog_morethanone = 0;
         catalog_add_file_records_from_dir(dr->name);   // also restores mmu6,7

         list_generate();
         memory_clear_file_records();
      }
   }

   memory_restore_dir();
}

int main(unsigned int argc, char **argv)
{
   static struct opt *found;
   
   // initialization
   
   old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   
   atexit(cleanup);
   
   // screen mode
   
   if (esx_ide_mode_get(&screen_mode))
      return (int)err_screen_mode;

   // environment variables
   
   if ((fin = esx_f_open(_ENV_FNAME, ESX_MODE_OPEN_EXIST | ESX_MODE_READ)) != 0xff)
   {
      unsigned char *val;
      
      // fob_blob[] is available memory at the end of the program that is not in use yet
      
      if (val = env_getenv(fin, TIME_STYLE, fob_blob + 512, 512, fob_blob, 512))
      {
         // TIME_STYLE found
         
         if (stricmp(val, "long-iso") == 0)
            flags.date_func = date_fmt_long_iso;
         else if (stricmp(val, "iso") == 0)
            flags.date_func = date_fmt_iso;
         else if (stricmp(val, "locale") == 0)
            flags.date_func = date_fmt_locale;
      }  
   
      esx_f_seek(fin, 0, ESX_SEEK_SET);
      
      if (val = env_getenv(fin, LS_COLOR, fob_blob + 512, 512, fob_blob, 512))
      {
         // LS_COLOR found
         
         parse_ls_color(val);
      }
      
      close_open_files();
   }
   
   // current month and year if available
   
   if (esx_m_getdate((struct dos_tm *)fob_blob) == 0)
   {
      tm_from_dostm(&date_tm, (struct dos_tm *)fob_blob);
      
      current_year = date_tm.tm_year;
      current_month = date_tm.tm_mon;
   }

   // parse options

   p_forward_list_init(&src);
   fob = obstack_init((struct obstack *)fob_blob, 0xffff - fob_blob);   // right to the top of memory
   
   qsort(options, sizeof(options)/sizeof(*options), sizeof(*options), sort_cmp_option);

   for (unsigned char i = 1; i < (unsigned char)argc; ++i)
   {
      // strip surrounding whitespace possibly from quoting
      
      argv[i] = strrstrip(strstrip(argv[i]));
      
      // check for option

      if (argv[i][0] == '-')
      {
         unsigned int ret;

         if (found = bsearch(argv[i], options, sizeof(options)/sizeof(*options), sizeof(*options), sort_opt_search))
         {
            // option is monolithic
            
            ret = (found->action)(&i, argc, argv);
         }
         else
         {
            unsigned char *p;
            static unsigned char op[] = "-x";
            
            // check if option is form -abc instead of -a -b -c
            // all must match
            
            for (p = &argv[i][1]; isalnum(*p); ++p)
            {
               op[1] = *p;
               
               if (bsearch(op, options, sizeof(options)/sizeof(*options), sizeof(*options), sort_opt_search) == 0)
                  break;
            }
            
            // if they all matched execute the options
            
            if (*p == 0)
            {
               for (p = &argv[i][1]; *p; ++p)
               {
                  op[1] = *p;
                  
                  found = bsearch(op, options, sizeof(options)/sizeof(*options), sizeof(*options), sort_opt_search);
                  ret = (found->action)(&i, argc, argv);

                  if (ret != OPT_ACTION_OK)
                     break;
               }
            }
         }
         
         if (found == 0) exit((int)err_invalid_option);
         if (ret != OPT_ACTION_OK) exit(ret);
      }
      else
      {
         // filename

         unsigned char *p;
         static struct file tmp;

         memset(&tmp, 0, sizeof(tmp));
         tmp.name = argv[i];

         // word is a file let's clean it up

         p = advance_past_drive(tmp.name);
         if (*p) strcpy(p, pathnice(p));

         // add to list of files

         if (*tmp.name)
         {
            strlwr(tmp.name);

            if ((p = obstack_copy(fob, &tmp, sizeof(tmp))) == 0)
               exit((int)err_out_of_memory);
            
            if (ptr)
            {
               // append to end of list
               ptr = p_forward_list_insert_after(ptr, p);
            }
            else
            {
               // first item in list
               ptr = p_forward_list_push_front(&src, p);
            }
         }
      }
   }
   
   if (flags.disp_width == 0)
      flags.disp_width = screen_mode.cols;

   // help

   if (flags.help)
   {
      // print compressed help text
      
      *dzx7_standard(ls_help, fob_blob) = 0;
      puts(fob_blob);
   }
   
   if (flags.help || flags.version)
   {
      puts(ls_version);
      exit(0);
   }

   // find current drive
   
   if ((current_drive[0] = tolower(esx_dos_get_drive())) == 0xff)
      exit(errno);

   // create ls groups
   // sources in the same directory are grouped together
   // do not create them if sorting is turned off to avoid duplicates in the same listing
   
   if (flags.sort_func && (ptr = p_forward_list_front(&src)))
   {
      ptr->canonical_path = getpath(ptr->name);
   
      for (current = p_forward_list_next(ptr); current; current = p_forward_list_next(ptr))
      {
         struct file *walk;

         current->canonical_path = getpath(current->name);
      
         // check if current should be part of a ls group in the src previous to it
      
         for (walk = p_forward_list_front(&src); walk != current; walk = p_forward_list_next(walk))
         {
            if (strcmp(walk->canonical_path, current->canonical_path) == 0)
               break;
         }
      
         if (walk != current)
         {
            // current belongs in ls group walk
         
            // first remove current from the main list
         
            p_forward_list_remove_after(ptr);
         
            // second add current to walk's peers
         
            p_forward_list_push_front(&(p_forward_list_t)walk->peer, &current->peer);
         }
         else
         {
            // advance lagger
         
            ptr = p_forward_list_next(ptr);
         }
      }
   
      // canonical paths are not needed anymore so free all that memory
   
      ptr = p_forward_list_front(&src);
      obstack_free(fob, ptr->canonical_path);
   }

   // src names are in divmmc memory
   
   // record start address of file record ptrs
   
   fbase = obstack_base(fob);
   fbase_sz = 0;
   
   // initialize the directory queue
   
   memory_clear_dir_queue();
   
   // no src names means the current directory is implied
   
   if (p_forward_list_empty(&src))
      catalog_add_dir_record(current_drive);

   // let's begin
   // iterate over all src files and their peers
   
   for (ptr = p_forward_list_front(&src); ptr; ptr = p_forward_list_next(ptr))
   {
      // opportunity for user to break
         
      user_interaction_spin();

      // clear all file records
      // file records are accumulated per src
      
      memory_clear_file_records();
      
      // record active canonical path
      
      if (esx_f_get_canonical_path(ptr->name, canonical_active))
         printf(" \nignoring invalid path:\n%s\n", ptr->name);
      else
      {
         strlwr(canonical_active);

         // point to list of peers
         
         current = p_forward_list_front(&(p_forward_list_t)ptr->peer);

         // inform catalog routine that src is being catalogued
      
         catalog_control = CATALOG_MODE_SRC;
         catalog_morethanone = (current != 0);
      
         // ptr points at the ls group with ptr being the valid parent entry
         // iterate over files matched to ptr
     
         catalog_add_file_records(ptr->name);
      
         // next visit peers

         while (current)
         {
            struct file *f;
         
            f = (struct file *)((unsigned char *)current - offsetof(struct file, peer));
         
            // f points at a peer in the ls group
            // iterate over files matched to f

            catalog_add_file_records(f->name);
            
            // next peer
            
            current = p_forward_list_next(current);
         }
      
         // generate listing
      
         list_generate();
      
         // visit the directory cache
      
         process_directory_cache();
      }
   }
   
   // if no src files were given the loop above was not entered

   process_directory_cache();

   return 0;
}
