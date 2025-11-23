#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <libgen.h>
#include <time.h>
#include <alloc/obstack.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>
#include <compress/zx7.h>
#include <errno.h>

#include "errors.h"
#include "move.h"
#include "mv.h"
#include "mv-help.h"
#include "options.h"
#include "user_interaction.h"


// SELECTED OPTIONS

struct flag flags = {
   0,                    // backup def: no backups
   FLAG_OVERWRITE_ASK,   // overwrite def: ask to overwrite
   0,                    // trailing slashes def: keep
   "bak",                // suffix def: backup extension
   0,                    // update def: no time check
   0,                    // verbose def: quiet
   0,                    // help
   0,                    // version
   0                     // include system files in src matches
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
   { "--version", OPT_TYPE_EXACT, (optfunc)option_exec_version },
   { "--system", OPT_TYPE_EXACT, (optfunc)option_exec_system }
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

// command line names

struct file *src;
unsigned char src_sz;

struct file dst;               // type is initially unknown

// detailed information

struct file_info source;
struct file_info destination;

// dos_catalog structures

extern struct esx_cat catalog;
extern struct esx_lfn lfn;

static unsigned char *name_in_main_memory;
static unsigned char *name_in_src;

// MEMORY MANAGEMENT

struct obstack *ob;
unsigned char blob[2048];      // make as large as program allows (this size is excessive)

// UTILITIES

unsigned char *advance_past_drive(unsigned char *p)
{
   return (isalpha(p[0]) && (p[1] == ':')) ? (p + 2) : p;
}

static unsigned char current_drive;

unsigned char get_drive(unsigned char *p)
{
   return (isalpha(p[0]) && (p[1] == ':')) ? p[0] : current_drive;
}

// MAIN

extern unsigned char fin;
extern unsigned char fout;

void close_open_files(void)
{
   if (fin != 0xff) esx_f_close(fin);
   if (fout != 0xff) esx_f_close(fout);
   
   fin = fout = 0xff;
}

unsigned char *cleanup_remove_name;
static unsigned char old_cpu_speed;

static void cleanup(void)
{
   close_open_files();
   
   if (cleanup_remove_name)
      esx_f_unlink(cleanup_remove_name);
   
   printf(" ");                // erase any cursor left behind
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
            strlwr(tmp.name);

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
      // this is a dotn dot command so memory is not a problem
      // but use this as an example of how to decompress help text
      
      *dzx7_standard(mv_help, blob) = 0;
      puts(blob);
   }
   
   if (flags.help || flags.version)
   {
      puts(mv_version);
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
   
   // find current drive
   
   if ((current_drive = tolower(esx_dos_get_drive())) == 0xff)
      exit(errno);

   // resolve to single destination
   // if the destination name contains wildcards it must match something

   if ((name_in_main_memory = obstack_copy(ob, dst.name, strlen(dst.name) + 1)) == 0)
      exit((int)err_out_of_memory);

   catalog.filter = ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN | ESX_CAT_FILTER_DIR;
   catalog.filename = p3dos_cstr_to_pstr(name_in_main_memory);
   catalog.cat_sz = 2;   // consistent with mv.asm

   if (esx_dos_catalog(&catalog) == 1)
   {
      unsigned char type;

      do
      {
         // opportunity for user to break

         user_interaction_spin();
         
         // keep looking until correct destination type found

         type = (catalog.cat[1].filename[7] & 0x80) ? FILE_TYPE_DIRECTORY : FILE_TYPE_NORMAL;
      
         if (dst.type == FILE_TYPE_UNKNOWN)
            dst.type = type;
      }
      while ((dst.type != type) && (esx_dos_catalog_next(&catalog) == 1));
      
      if (dst.type != type)
         exit((int)err_destination_wrong_type);

      lfn.cat = &catalog;
      esx_ide_get_lfn(&lfn, &catalog.cat[1]);

      obstack_free(ob, name_in_main_memory);

      if ((name_in_main_memory = obstack_alloc(ob, basename(dst.name) - dst.name + strlen(lfn.filename) + 1)) == 0)
         exit((int)err_out_of_memory);

      sprintf(name_in_main_memory, "%.*s%s", basename(dst.name) - dst.name, dst.name, lfn.filename);
      dst.name = name_in_main_memory;

      memcpy(&destination.time, &lfn.time, sizeof(destination.time));
      destination.exists = 1;
   }
   else
   {
      dst.name = p3dos_pstr_to_cstr(name_in_main_memory);

      if (strpbrk(dst.name, "*?"))
         exit((int)err_destination_contains_wildcards);
   }

   if (dst.type == FILE_TYPE_UNKNOWN)
      dst.type = FILE_TYPE_NORMAL;

   strlwr(dst.name);

   destination.name = dst.name;
   destination.type = dst.type;

   if (esx_f_get_canonical_path(dst.name, lfn.filename))
      exit(ESX_EPATH);

   if ((destination.canonical_name = obstack_alloc(ob, strlen(lfn.filename) + strlen(basename(dst.name)) + 1)) == 0)
      exit((int)err_out_of_memory);

   sprintf(destination.canonical_name, "%s%s", lfn.filename, basename(dst.name));
   strlwr(destination.canonical_name);

   // destination names are in main memory

   if (flags.verbose)
   {
      puts(" \nMV");
      printf("SRC files = %u\n", src_sz);
      printf("DST is a %s\n%s\n", (destination.type == FILE_TYPE_NORMAL) ? "file" : "directory", destination.canonical_name);
   }

   // let the good times roll

   for (unsigned char i = 0; i < src_sz; ++i)
   {
      unsigned char another;
      
      // opportunity for user to break

      user_interaction_spin();

      // init catalog structure for match on source file

      name_in_src = src[i].name;
      
      if ((name_in_main_memory = obstack_copy(ob, name_in_src, strlen(name_in_src) + 1)) == 0)
         exit((int)err_out_of_memory);

      if (flags.verbose)
         printf(" \nMatching \"%s\"\n", name_in_main_memory);

      catalog.filter = (flags.system) ? (ESX_CAT_FILTER_SYSTEM | ESX_CAT_FILTER_LFN) : (ESX_CAT_FILTER_LFN);
      if ((src[i].type == FILE_TYPE_DIRECTORY) || ((src[i].type == FILE_TYPE_UNKNOWN) && (src_sz == 1)))
         catalog.filter |= ESX_CAT_FILTER_DIR;

      catalog.filename = p3dos_cstr_to_pstr(name_in_main_memory);
      catalog.cat_sz = 2;   // consistent with mv.asm
      
      // iterate over all source file matches
      // doing one at a time avoids complications with wildcards and new files being created

      if (esx_dos_catalog(&catalog) == 1)
      {
         // lfn details for this file
            
         lfn.cat = &catalog;
         esx_ide_get_lfn(&lfn, &catalog.cat[1]);

         do
         {
            unsigned char ret;
            
            // opportunity for user to break

            user_interaction_spin();

            // fill in source file details
            
            memset(&source, 0, sizeof(source));
      
            if ((source.name = obstack_alloc(ob, basename(name_in_src) - name_in_src + strlen(lfn.filename) + 1)) == 0)
               exit((int)err_out_of_memory);
            
            sprintf(source.name, "%.*s%s", basename(name_in_src) - name_in_src, name_in_src, lfn.filename);
            strlwr(source.name);

            source.type = (catalog.cat[1].filename[7] & 0x80) ? FILE_TYPE_DIRECTORY : FILE_TYPE_NORMAL;
            
            memcpy(&source.time, &lfn.time, sizeof(source.time));
            source.exists = 1;
            
            // find out if there is another match before the move voids this file
            // get the corresponding lfn
            
            if ((another = esx_dos_catalog_next(&catalog)) == 1)
            {
               lfn.cat = &catalog;
               esx_ide_get_lfn(&lfn, &catalog.cat[1]);
            }
            
            // action is based on source and destination types
            // source, destination, src, dst all have their own memory so further allocation is safe

            ret = 0;
            
            switch (move_classify(source.type, destination.type))
            {
               case MOVE_TYPE_FILE_TO_FILE:
               
                  if (flags.verbose)
                     printf(" \nMoving file \"%s\" to file \"%s\"\n", source.name, destination.name);

                  if (ret = move_file_to_file((void*)&source, (void*)&destination))
                     printf("MV failed with code %u\n", ret);
                  
                  exit(0);
                  break;
                  
               case MOVE_TYPE_FILE_TO_DIR:
               
                  if (flags.verbose)
                     printf(" \nMoving file \"%s\" to dir \"%s\"\n", source.name, destination.name);
                  
                  ret = move_file_to_dir((void*)&source, (void*)&destination);
                  
                  break;
                  
               case MOVE_TYPE_DIR_TO_FILE:
               
                  // silently ignore this one
                  break;
                  
               case MOVE_TYPE_DIR_TO_DIR:
               
                  if (flags.verbose)
                     printf(" \nMoving dir \"%s\" to dir \"%s\"\n", source.name, destination.name);
                  
                  ret = move_dir_to_dir((void*)&source, (void*)&destination);

                  break;
                  
               default:
               
                  if (flags.verbose)
                     puts(" \nDebug: classify error");

                  break;
            }

            if (ret) printf("MV failed with code %u\n", ret);
            
            obstack_free(ob, source.name);   // also frees memory allocated after this
         }
         while (another == 1);
      }
      
      obstack_free(ob, name_in_main_memory);
   }

   return 0;
}
