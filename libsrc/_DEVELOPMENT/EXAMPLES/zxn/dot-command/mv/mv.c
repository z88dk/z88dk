// zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o mvtmp -pragma-include:zpragma.inc -subtype=dotn -Cz"--clean" -create-app --list -m --c-code-in-asm

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <libgen.h>
#include <time.h>
#include <alloc/obstack.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>
#include <input.h>
#include <errno.h>

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

unsigned char dst_resolved;    // non-zero if dst info gathered
struct dos_tm dst_time;

extern struct esx_cat catalog;
extern struct esx_lfn lfn;

unsigned char *name_in_main_memory;

// MEMORY MANAGEMENT

struct obstack *ob;
unsigned char blob[1024];      // make as large as program allows

// UTILITIES

unsigned char *advance_past_drive(unsigned char *p)
{
   return (isalpha(p[0]) && (p[1] == ':')) ? (p + 2) : p;
}

// USER INTERACTION

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
static unsigned char cursor[] = "-\\|/";

unsigned char user_interaction_spin(void)
{
   printf("%c" "\x08", cursor[cpos]);
   if (++cpos >= (sizeof(cursor) - 1)) cpos = 0;
   
   return user_interaction();
}

// MAIN

static unsigned char old_cpu_speed;

static void cleanup(void)
{
   printf(" \n");   // erase any cursor left behind
   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
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
         else
         {
            unsigned char *p;
            static unsigned char op[] = "-x";
            
            // check if option is form -abc instead of -a -b -c
            // all must match
            
            for (p = &argv[i][1]; isalnum(*p); ++p)
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
      }
      else
      {
         // filename

         unsigned char c;
         unsigned char *p;
         static struct file tmp;

         tmp.name = argv[i];
         tmp.type = FILE_TYPE_UNKNOWN;
         
         // look for trailing slash before clean up
         
         p = tmp.name;
         c = p[strlen(p) - 1];
         
         if ((flags.slashes == 0) && ((c == '/') || (c == '\\')))
            tmp.type = FILE_TYPE_DIRECTORY;
         
         // word is a file let's clean it up

         p = advance_past_drive(p);
         
         if (isspace(*p)) exit(ESX_EINVAL);
         if (*p) strcpy(p, pathnice(p));
         
         // if there are wildcards then this is not a directory
         
         if ((tmp.type == FILE_TYPE_UNKNOWN) && strpbrk(tmp.name, "*?"))
            tmp.type = FILE_TYPE_NORMAL;
         
         // add to list of files

         if (*tmp.name)
         {
            if (obstack_grow(ob, &tmp, sizeof(tmp)) == 0)
               exit((int)err_out_of_memory);
            
            ++src_sz;
         }
      }
   }

   // help
   
   if ((flags.version == 0) && ((src_sz + (dst.name != 0)) < 2))
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
   
   if ((src_sz > 1) || (src[0].type == FILE_TYPE_DIRECTORY))
   {
      if (dst.type == FILE_TYPE_NORMAL)
         exit((int)err_destination_not_directory);
      
      dst.type = FILE_TYPE_DIRECTORY;
   }

for (unsigned char k = 0; k < src_sz; ++k)
	printf("src[%u] = \"%s\" %u\n", k, src[k].name, src[k].type);

printf("dst = \"%s\" %u\n", dst.name, dst.type);


   // if the destination name contains wildcards it must match something

   if ((name_in_main_memory = obstack_copy(ob, dst.name, strlen(dst.name) + 1)) == 0)
      exit((int)err_out_of_memory);

printf("name = \"%s\" at 0x%04x\n", name_in_main_memory, name_in_main_memory);

   catalog.filter = (dst.type == FILE_TYPE_NORMAL) ? (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN) : (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN | ESX_CAT_FILTER_DIR);
   catalog.filename = p3dos_cstr_to_pstr(name_in_main_memory);
   catalog.cat_sz = 2;   // consistent with mv.asm

printf("name end = %u\n", strchr(name_in_main_memory, 0xff) - name_in_main_memory);
printf("errno = %u, dos_catalog = %u, errno = %u\n", errno, esx_dos_catalog(&catalog), errno);
printf("completed_sz = %u\n", catalog.completed_sz);

   if (esx_dos_catalog(&catalog) == 1)
   {
      unsigned char type;
printf("hello\n");
      do
      {
         // opportunity for user to break

         if (user_interaction_spin())
            exit((int)err_break_into_program);
         
         // keep looking until correct destination type found

         type = (catalog.cat[1].filename[7] & 0x80) ? FILE_TYPE_DIRECTORY : FILE_TYPE_NORMAL;
      
         if (dst.type == FILE_TYPE_UNKNOWN)
            dst.type = type;
      }
      while ((dst.type != type) && (esx_dos_catalog_next(&catalog) == 1));
      
      if (dst.type != type) exit(2);

      lfn.cat = &catalog;
      if (esx_ide_get_lfn(&lfn, &catalog.cat[1]) == 0xff)
			printf("dst lfn error %u\n", errno);
      
      obstack_free(ob, name_in_main_memory);

      if ((dst.name = obstack_copy(ob, &lfn.filename, strlen(lfn.filename) + 1)) == 0)
         exit((int)err_out_of_memory);
      
      memcpy(&dst_time, &lfn.time, sizeof(dst_time));
      dst_resolved = 1;
   }
   else
   {
      dst.name = p3dos_pstr_to_cstr(name_in_main_memory);

      if (strpbrk(dst.name, "*?"))
         exit((int)err_destination_contains_wildcards);
   }

   if (dst.type == FILE_TYPE_UNKNOWN)
      dst.type = FILE_TYPE_NORMAL;
   
   // dst.name is in main memory


for (unsigned char k = 0; k < src_sz; ++k)
	printf("src[%u] = \"%s\" %u\n", k, src[k].name, src[k].type);

printf("dst = \"%s\" %u\n", dst.name, dst.type);



   // let the good times roll

   for (unsigned char i = 0; i < src_sz; ++i)
   {
      // opportunity for user to break

      if (user_interaction_spin())
         exit((int)err_break_into_program);

      // init catalog structure for match on source file

      if ((name_in_main_memory = obstack_copy(ob, src[i].name, strlen(src[i].name) + 1)) == 0)
         exit((int)err_out_of_memory);

printf("name = \"%s\" at 0x%04x\n", name_in_main_memory, name_in_main_memory);

      catalog.filter = (src[i].type == FILE_TYPE_NORMAL) ? (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN) : (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN | ESX_CAT_FILTER_DIR);
      catalog.filename = p3dos_cstr_to_pstr(name_in_main_memory);
      catalog.cat_sz = 2;   // consistent with mv.asm

printf("name end = %u\n", strchr(name_in_main_memory, 0xff) - name_in_main_memory);

      // iterate over all source file matches
      // doing one at a time avoids complications with wildcards and new files being created

printf("errno = %u, dos_catalog = %u, errno = %u\n", errno, esx_dos_catalog(&catalog), errno);
printf("completed_sz = %u\n", catalog.completed_sz);

      if (esx_dos_catalog(&catalog) == 1)
      {
printf("hello\n");
         do
         {
            // opportunity for user to break

            if (user_interaction_spin())
               exit((int)err_break_into_program);
            
            // lfn details for this file
            
            lfn.cat = &catalog;
            if (esx_ide_get_lfn(&lfn, &catalog.cat[1]) == 0xff)
					printf("src lfn error %u\n", errno);
            
            // action is based on source and destination types
            
            switch (move_classify(catalog.cat[1].filename[7], dst.type))
            {
               case MOVE_TYPE_FILE_TO_FILE:
                  move_file_to_file();
                  // do we finish here?  do we allow the destination to be written many times?
                  exit(0);
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
         while (esx_dos_catalog_next(&catalog) == 1);
      }
      
      obstack_free(ob, name_in_main_memory);
   }

   return 0;
}
