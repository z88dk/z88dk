#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <libgen.h>
#include <alloc/obstack.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>
#include <input.h>

#include "errors.h"
#include "move.h"
#include "mv.h"
#include "options.h"

// SELECTED OPTIONS

struct flag flags = {
   0,                    // backup def: no backups
   FLAG_OVERWRITE_ASK,   // overwrite def: ask to overwrite
   0,                    // trailing slashes def: keep
   "bak",                // suffix def: backup extension
   0,                    // update def: no time check
   0,                    // verbose def: quiet
   0,                    // help
   0                     // version
};

// ACCEPTED OPTIONS

static struct opt options[] = {
   { "-b", OPT_TYPE_EXACT, (optfunc)option_exec_b },
   { "-f", OPT_TYPE_EXACT, (optfunc)option_exec_f },
   { "--force", OPT_TYPE_EXACT, (optfunc)option_exec_f },
   { "-i", OPT_TYPE_EXACT, (optfunc)option_exec_i },
   { "--interactive", OPT_TYPE_EXACT, (optfunc)option_exec_i },
   { "-n", OPT_TYPE_EXACT, (optfunc)option_exec_n },
   { "--strip-trailing-slashes", OPT_TYPE_EXACT, (optfunc)option_exec_strip_slashes },
   { "--no-clobber", OPT_TYPE_EXACT, (optfunc)option_exec_n },
   { "-S", OPT_TYPE_EXACT, (optfunc)option_exec_S },
   { "--suffix=", OPT_TYPE_LEADING, (optfunc)option_exec_suffix },
   { "-t", OPT_TYPE_EXACT, (optfunc)option_exec_t },
   { "--target-directory=", OPT_TYPE_LEADING, (optfunc)option_exec_target_directory },
   { "-T", OPT_TYPE_EXACT, (optfunc)option_exec_T },
   { "--no-target-directory", OPT_TYPE_EXACT, (optfunc)option_exec_T },
   { "-u", OPT_TYPE_EXACT, (optfunc)option_exec_u },
   { "--update", OPT_TYPE_EXACT, (optfunc)option_exec_u },
   { "-v", OPT_TYPE_EXACT, (optfunc)option_exec_v },
   { "--verbose", OPT_TYPE_EXACT, (optfunc)option_exec_v },
   { "-h", OPT_TYPE_EXACT, (optfunc)option_exec_help },
   { "--help", OPT_TYPE_EXACT, (optfunc)option_exec_help },
   { "--version", OPT_TYPE_EXACT, (optfunc)option_exec_version }
};

static int compare_option_sort(struct opt *a, struct opt *b)
{
   return strcmp(a->name, b->name);
}

static int compare_option_search(unsigned char *name, struct opt *a)
{
   if (a->type == OPT_TYPE_EXACT)
      return strcmp(name, a->name);
   
   return strncmp(name, a->name, strlen(a->name));
}

// FILES

struct file *src;
unsigned char src_sz;

struct file dst;               // type is unknown

unsigned char dstat_avail;     // non-zero if dst stat filled in
struct esx_stat dstat;

extern struct esx_cat catalog;
extern struct esx_lfn lfn;

// MEMORY MANAGEMENT

struct obstack *ob;
unsigned char blob[1024];      // make as large as program allows

// UTILITIES

unsigned char *advance_past_drive(unsigned char *p)
{
   return (isalpha(p[0]) && (p[1] == ':')) ? (p + 2) : p;
}

// MAIN

static unsigned char old_cpu_speed;

static void cleanup(void)
{
   printf(" \n");   // erase any cursor left behind
   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
}

unsigned char user_interaction(void)
{
   if (in_key_pressed(IN_KEY_SCANCODE_SPACE | 0x8000))
   {
      printf("<break>\n");

      in_wait_nokey();
      return 1;
   }
   
   return 0;
}

static unsigned char cpos;
static unsigned char cursor[] = "-\|/";

unsigned char user_interaction_spin(void)
{
   printf("%c" "\x08", cursor[cpos]);
   if (++cpos >= (sizeof(cursor) - 1)) cpos = 0;
   
   return user_interaction();
}

int main(int argc, char **argv)
{
   static struct opt *found;

   // initialization
   
   old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   
   atexit(cleanup);
   
   ob = obstack_init((struct obstack *)blob, sizeof(blob));
   qsort(options, sizeof(options)/sizeof(*options), sizeof(*options), compare_option_sort);
   
   // parse options
   
   for (unsigned char i = 1; i < (unsigned char)argc; ++i)
   {
      // strip surrounding whitespace possibly from quoting
      
      argv[i] = strrstrip(strstrip(argv[i]));
      
      // check for option

      if (argv[i][0] == '-')
      {
         unsigned int ret;

         if (found = bsearch(argv[i], options, sizeof(options)/sizeof(*options), sizeof(*options), compare_option_search))
         {
            // option is monolithic
            
            ret = (found->action)(&i, argc, argv);
         }
         else if (argv[i][1] && (argv[i][1] != '-'))
         {
            unsigned char *p;
            static unsigned char op[] = "-x";
            
            // check if option is form -abc instead of -a -b -c
            // all must match
            
            for (p = &argv[i][1]; *p; ++p)
            {
               op[1] = *p;
               
               if (bsearch(op, options, sizeof(options)/sizeof(*options), sizeof(*options), compare_option_search) == 0)
                  break;
            }
            
            // if they all matched execute the options
            
            if (*p == 0)
            {
               for (p = &argv[i][1]; *p; ++p)
               {
                  op[1] = *p;
                  
                  found = bsearch(op, options, sizeof(options)/sizeof(*options), sizeof(*options), compare_option_search);
                  ret = (found->action)(&i, argc, argv);

                  if (ret != OPT_ACTION_OK)
                     break;
               }
            }
         }
         
         if (found == 0) exit((int)err_invalid_option);
         if (ret != OPT_ACTION_OK) exit(ret);
         
         continue;
      }

      // filename

      {
         unsigned char c;
         unsigned char *p;
         static struct file tmp;
         
         tmp.type = FILE_TYPE_UNKNOWN;
         
         // look for trailing slash before clean up
         
         p = argv[i];
         c = p[strlen(p) - 1];
         
         if ((flags.slashes == 0) && ((c == '/') || (c == '\\')))
            tmp.type = FILE_TYPE_DIRECTORY;
         
         // word is a file let's clean it up

         p = advance_past_drive(p);
         
         if (isspace(*p)) exit(ESX_EINVAL);
         if (*p) strcpy(p, pathnice(p));
         
         // add to list of files
         
         tmp.name = argv[i];
         
         if (*tmp.name == 0) continue;
         
         if (obstack_grow(ob, &tmp, sizeof(tmp)) == 0)
            exit((int)err_out_of_memory);
         
         ++src_sz;
      }
   }

   // help
   
   if ((src_sz + (dst.name != 0)) < 2)
      flags.help = 1;
   
   if (flags.help)
   {
      printf("HELP!\n");
   }
   
   if (flags.help || flags.version)
   {
      printf("VERSION!\n");
      exit(0);
   }
   
   // finalize sources and destination
   
   src = obstack_finish(ob);
   
   if (dst.name == 0)
   {
      dst.name = src[--src_sz].name;
      
      if (dst.type == FILE_TYPE_UNKNOWN)
         dst.type = src[src_sz].type;
   }
   
   if (src_sz > 1)
   {
      if (dst.type == FILE_TYPE_NORMAL)
         exit((int)err_destination_not_directory);
      
      dst.type = FILE_TYPE_DIRECTORY;
   }
   
   // if the destination name contains wildcards it must match something
   
   if (strpbrk(dst.name, "*?"))
   {
      unsigned char num;
      
      catalog.filter = (dst.type == FILE_TYPE_NORMAL) ? (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN) : (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN | ESX_CAT_FILTER_DIR);
      catalog.filename = dst.name;
      
      if ((num = esx_dos_catalog(&catalog)) && (num != 0xff))
      {
         unsigned char type;
         
         type = (catalog.cat[1].filename[7] & 0x80) ? FILE_TYPE_DIRECTORY : FILE_TYPE_NORMAL;
         
         if (dst.type == FILE_TYPE_UNKNOWN)
         {
            dst.type = type;
         }
         else if (dst.type != type)
         {
            exit((int)err_destination_type_mismatch);
         }
         
         lfn.dir = &catalog;

         if (esx_ide_get_lfn(&lfn, &catalog.cat[j]))
            exit((int)err_destination_contains_wildcards);

         if ((dst.name = obstack_copy(ob, &lfn.filename, strlen(lfn.filename) + 1) == 0)
            exit((int)err_out_of_memory);
      }
      else
      {
         exit((int)err_destination_contains_wildcards);
      }
   }
   
   // let the good times roll

   for (unsigned char i = 0; i < src_sz; ++i)
   {
      unsigned char num;

      // opportunity for user to break

      if (user_interaction_spin())
         exit((int)err_break_into_program);

      // init catalog structure for match on source file
      // note catalog.cat_sz is initialized in mv.asm

      catalog.filter = (src[i].type == FILE_TYPE_NORMAL) ? (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN) : (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN | ESX_CAT_FILTER_DIR);
      catalog.filename = src[i].name;
      
      num = esx_dos_catalog(&catalog);

      while (num && (num != 0xff))
      {
         // source files found

         if (dst.type == FILE_TYPE_UNKNOWN)
         {
            // still don't know if destination is a directory or not, now we can determine that

            dst.type = ((catalog.completed_sz > 1) || (catalog.cat[1].filename[7] & 0x80)) ? FILE_TYPE_DIRECTORY : FILE_TYPE_NORMAL;
         }
         
         // fill destination stat file at first chance
         
         if (dstat_avail == 0)
         {
            if (esx_f_stat(dst.name, &dstat) == 0)
               dstat_avail = 1;
         }

         // iterate over all matches

         for (unsigned char j = 1; j <= num; ++j)
         {
            // opportunity for user to break

            if (user_interaction_spin())
               exit((int)err_break_into_program);

            // lfn details for this file

            lfn.dir = &catalog;

            if (esx_ide_get_lfn(&lfn, &catalog.cat[j]) == 0)
            {
               // action is based on src and dst file types

               switch(move_classify(catalog.cat[j].filename[7], dst.type))
               {
                  case MOVE_TYPE_FILE_TO_FILE:
                     move_file_to_file();
                     break;
                  
                  case MOVE_TYPE_FILE_TO_DIR:
                     move_file_to_dir();
                     break;
                  
                  case MOVE_TYPE_DIR_TO_FILE:
                     // silently ignore this one
                     break;
                  
                  case MOVE_TYPE_DIR_TO_DIR:
                     move_dir_to_dir();
                     break;
                  
                  default:
                     printf("debug: classify error\n");
                     break;
               }
            }
            else
            {
               printf("debug: ide_get_lfn failed\n");
            }
         }

         num = esx_dos_catalog_next(&catalog);
      }
   }

   return 0;
}
