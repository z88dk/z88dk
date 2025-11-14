/*
 * FIND files
 * aralbrec@z88dk.org
*/
 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <ctype.h>
#include <errno.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>
#include <compress/zx7.h>
#include <alloc/obstack.h>

#include "criteria.h"
#include "directory.h"
#include "errors.h"
#include "find.h"
#include "find-help.h"
#include "options.h"
#include "prune.h"
#include "user_interaction.h"


// MANAGE MEMORY

struct obstack *ob;
extern unsigned char obmem[];


// SELECTED OPTIONS

struct flag flags = {
   1,             // minimum search depth
   255,           // maximum search depth
   FLAG_LFN_ON,   // print lfn names
   0,             // do not change to directory
   0,             // help
   0              // version
};


// ACCEPTED OPTIONS

static struct opt options[] = {
   { "-name", OPT_TYPE_EXACT, (optfunc_t)option_exec_name },
   { "-name=", OPT_TYPE_LEADING, (optfunc_t)option_exec_name_eq },
   { "-mindepth", OPT_TYPE_EXACT, (optfunc_t)option_exec_mindepth },
   { "-mindepth=", OPT_TYPE_LEADING, (optfunc_t)option_exec_mindepth_eq },
   { "-maxdepth", OPT_TYPE_EXACT, (optfunc_t)option_exec_maxdepth },
   { "-maxdepth=", OPT_TYPE_LEADING, (optfunc_t)option_exec_maxdepth_eq },
   { "-type", OPT_TYPE_EXACT, (optfunc_t)option_exec_type },
   { "-type=d", OPT_TYPE_EXACT, (optfunc_t)option_exec_type_d },
   { "-type=f", OPT_TYPE_EXACT, (optfunc_t)option_exec_type_f },
   { "-size", OPT_TYPE_EXACT, (optfunc_t)option_exec_size },
   { "-size=", OPT_TYPE_LEADING, (optfunc_t)option_exec_size_eq },
   { "-mtime", OPT_TYPE_EXACT, (optfunc_t)option_exec_mtime },
   { "-mtime=", OPT_TYPE_LEADING, (optfunc_t)option_exec_mtime_eq },
   { "-mmin", OPT_TYPE_EXACT, (optfunc_t)option_exec_mmin },
   { "-mmin=", OPT_TYPE_LEADING, (optfunc_t)option_exec_mmin_eq },
   { "-exec", OPT_TYPE_EXACT, (optfunc_t)option_exec_exec },
   { "-prune", OPT_TYPE_EXACT, (optfunc_t)option_exec_prune },
   { "-prune=", OPT_TYPE_LEADING, (optfunc_t)option_exec_prune_eq },
   { "-lfn=on", OPT_TYPE_EXACT, (optfunc_t)option_exec_lfn_on },
   { "-lfn=off", OPT_TYPE_EXACT, (optfunc_t)option_exec_lfn_off },
   { "-lfn=both", OPT_TYPE_EXACT, (optfunc_t)option_exec_lfn_both },
   { "-cd", OPT_TYPE_EXACT, (optfunc_t)option_exec_cd },
   { "-cd=", OPT_TYPE_LEADING, (optfunc_t)option_exec_cd_eq },
   { "-help", OPT_TYPE_EXACT, (optfunc_t)option_exec_help },
   { "-version", OPT_TYPE_EXACT, (optfunc_t)option_exec_version }
};


// GLOBAL

struct dir_record *dir;            // directory being visited

struct esx_dirent dirent_sfn;      // file entry being visited
struct esx_dirent_lfn dirent_lfn;  // file entry being visited


// MAIN

unsigned char *advance_past_drive(unsigned char *p)
{
   return (isalpha(p[0]) && (p[1] == ':')) ? (p + 2) : p;
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
   puts("     ");                     // erase any cursor left behind
   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
}

int main(unsigned int argc, char **argv)
{
   static unsigned int num;
   static unsigned char first;
   static unsigned char dirnam[ESX_PATHNAME_MAX + 1];
   static struct opt *found;

   // initialization
   
   old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);

   atexit(cleanup);

   ob = obstack_init((struct obstack *)obmem, 0xffff - obmem);

   criteria_clear_list();
   prune_clear_list();

   prune_add_list("C:/GIT~1/");   // for people who clone directly to sd card
   prune_add_list("D:/GIT~1/");

   // parse options

   qsort(options, sizeof(options)/sizeof(*options), sizeof(*options), sort_cmp_option);
   
   if (argc > 1)
   {
      unsigned char *p;

      p = argv[1] = strrstrip(strstrip(argv[1]));
      
      if ((strcmp(p, "-help") == 0) || (strcmp(p, "--help") == 0))
         flags.help = 1;
      else if ((strcmp(p, "-version") == 0) || (strcmp(p, "--version") == 0))
         flags.version = 1;
      else
      {
         unsigned char *q;
         
         // start directory
      
         q = advance_past_drive(p);
         if (*q) strcpy(q, pathnice(q));

         if ((strcmp(p, ".") == 0) || (strcmp(p, "..") == 0))
         {
            esx_f_getcwd(dirnam);
         
            if (strcmp(p, "..") == 0)
            {
               strcat(dirnam, "../");
            
               if (esx_f_get_canonical_path(dirnam, dirnam))
                  exit(ESX_EPATH);
            }
         }
         else
         {
            strcpy(dirnam, p);
            if (*q && strcmp(q, "/")) strcat(dirnam, "/");
         
            if (esx_f_get_canonical_path(dirnam, dirnam))
               exit(ESX_EPATH);
         }

         // iterate over command line
      
         for (unsigned char i = 2; i < (unsigned char)argc; ++i)
         {
            unsigned int ret;
         
            // strip surrounding whitespace possibly from quoting
         
            argv[i] = strrstrip(strstrip(argv[i]));
         
            // accept leading double minus
         
            if (strncmp(argv[i], "--", 2) == 0)
               ++argv[i];
         
            // check for option
         
            if ((found = bsearch(argv[i], options, sizeof(options)/sizeof(*options), sizeof(*options), sort_opt_search)) == 0)
               exit((int)err_invalid_option);
         
            // execute option
         
            if ((ret = (found->action)(&i, argc, argv)) != OPT_ACTION_OK)
               exit(ret);
         }
      }
   }
   
   if (flags.maxdepth > 17)
      flags.maxdepth = 17;     // to prevent buffer overflow in directory name
   
   if (flags.mindepth > flags.maxdepth)
      exit((int)err_depth_order);
   
   // help
   
   if ((*dirnam == 0) && (flags.version == 0))
      flags.help = 1;
   
   if (flags.help)
   {
      // print compressed help text
      
      *dzx7_standard(find_help, obmem) = 0;
      puts(obmem);
   }
   
   if (flags.help | flags.version)
   {
      puts(find_version);
      exit(0);
   }

   // initialize directory queue
   // no more allocations from ob after this point

   dir_start = obstack_finish(ob);
   dir_end = (unsigned char *)0xffff;

   directory_clear_queue();
   directory_add(dirnam, 1);
   
   // find loop
   
   num = 0;

   while (dir = p_queue_front(&dir_queue))
   {
      static unsigned char *construct;
      static unsigned char *dirpath;

      user_interaction_spin_report(dir->level);
      
      dirpath = dir->path;

      // create workspace to construct names
      
      strcpy(dirnam, dirpath);
      construct = dirnam + strlen(dirnam);
      
      // 1. Add directories to search if maxdepth is not exceeded
      // 2. Apply matching criteria if mindepth is met
      
      // open twice to get both 8.3 and lfn
      
      fin = esx_f_opendir(dirpath);
      gin = esx_f_opendir_ex(dirpath, ESX_DIR_USE_LFN);
      
      first = 1;
      
      if ((fin == 0xff) || (gin == 0xff))
         printf("     \nunable to open %s\n", dirpath);
      else
      {
         while ((esx_f_readdir(fin, &dirent_sfn) == 1) && (esx_f_readdir(gin, &dirent_lfn) == 1))
         {
            user_interaction_spin_report(dir->level);

            // 1. Directories
            
            if ((dirent_sfn.attr & ESX_DIR_A_DIR) && (dir->level < flags.maxdepth))
            {
               // rule out "." and ".."
               
               if ((strcmp(dirent_sfn.name, ".") != 0) && (strcmp(dirent_sfn.name, "..") != 0))
               {
                  // construct pathname
            
                  strcat(strcpy(construct, strupr(dirent_sfn.name)), "/");

                  // 3. Prune excluded directories
                     
                  if (prune_apply(dirnam) == 0)
                     directory_add(dirnam, dir->level + 1);
               }
            }
            
            // 2. Apply criteria
            
            if ((dir->level >= flags.mindepth) && criteria_apply())
            {
               // print information about match
               
               if (first)
               {
                  first = 0;
                  printf("     \n%s\n\n", dirpath);
               }
               
               printf("%u - ", ++num);

               if (flags.lfn & FLAG_LFN_OFF)
                  printf("%s ", dirent_sfn.name);
               
               if (flags.lfn & FLAG_LFN_ON)
                  printf("%s", dirent_lfn.name);
               
               puts("");
               
               // change to directory
               
               if (flags.cd && (flags.cd == num))
               {
                  puts("\nchanging to directory");
                  
                  errno = 0;
                  esx_f_chdir(dirpath);
                  
                  exit(errno);
               }
            }
         }
      }
      
      close_open_files();
      
      p_queue_pop(&dir_queue);
   }
      
   return 0;
}  
