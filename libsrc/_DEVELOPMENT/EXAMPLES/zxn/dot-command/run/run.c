/*
 * RUN program with PATH search
 * aralbrec@z88dk.org
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <libgen.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>
#include <errno.h>

#include "error.h"
#include "load.h"
#include "option.h"
#include "path.h"
#include "run.h"
#include "run-help.h"
#include "sort.h"
#include "user_interaction.h"

// GLOBAL

unsigned char name[64];                          // filename being matched
unsigned char PATH[PATHSZ];                      // environment variable PATH
unsigned char cwd[ESX_PATHNAME_MAX + 1] = "/";   // current working directory
unsigned char current_drive[] = "C:/";
unsigned char buffer[512];

struct esx_dirent dirent_sfn;
struct esx_dirent_lfn dirent_lfn;

unsigned char mode48;

// OPTIONS

struct flag flags = {
   0,                          // option
   0                           // select Nth
};

static struct opt options[] = {
   { "-?", OPT_TYPE_EXACT, (optfunc_t)option_exec_question },
   { "-p", OPT_TYPE_EXACT, (optfunc_t)option_exec_path },
   { "-c", OPT_TYPE_EXACT, (optfunc_t)option_exec_cd },
   { "-r", OPT_TYPE_EXACT, (optfunc_t)option_exec_cwd },
};

// FILE TYPES

struct type types[] = {
   { ".tap", load_tap },
   { ".sna", load_snap },
   { ".snx", load_snap },
   { ".z80", load_snap },
   { ".o", load_snap },
   { ".p", load_snap },
   { ".nex", load_nex },
   { ".dot", load_dot },
   { ".bas", load_bas }
};

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
   path_close();
   close_open_files();

   puts(" ");                          // erase any cursor left behind

   if ((flags.option & (FLAG_OPTION_CWD | FLAG_OPTION_CD)) == FLAG_OPTION_CWD)
      esx_f_chdir(cwd);

   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
}

extern unsigned char _ENV_FNAME[];     // environment file defined by library

int main(unsigned int argc, char **argv)
{
   static unsigned char *p;
   static struct opt *found;
   static struct type *tfound;
   static unsigned char first;
   static unsigned int num;

   // initialization

   old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);

   esx_f_getcwd(cwd);
   current_drive[0] = cwd[0];

   atexit(cleanup);
   
   // esxdos is ruled out by the crt
   
   mode48 = (esx_m_dosversion() == ESX_DOSVERSION_NEXTOS_48K);

   // parse options

   qsort(options, sizeof(options)/sizeof(*options), sizeof(*options), sort_option);

   for (unsigned char i = 1; i < (unsigned char)argc; ++i)
   {
      unsigned int ret;

      // strip surrounding whitespace possibly from quoting

      p = strrstrip(strstrip(argv[i]));

      // check for option

      if (found = bsearch(p, options, sizeof(options)/sizeof(*options), sizeof(*options), find_option))
      {
         if ((ret = (found->action)()) != OPT_ACTION_OK)
            exit(ret);
      }
      else
      {
         // check for -N

         if ((*p == '-') && option_unsigned_number(p + 1, &ret))
         {
            flags.n = ret;
         }
         else
         {
            // must be a name

            if (*name) exit((int)err_multiple_name);
            strlcpy(name, p, sizeof(name));
         }
      }
   }

   // help

   if (((flags.option & (FLAG_OPTION_Q | FLAG_OPTION_PATH)) == 0) && (*name == 0))
   {
      puts(run_help);
      exit(0);
   }

   // filename

   p = basename(advance_past_drive(name));
   printf("\nFilename... %s\n", *name ? p : "<none>");

   // environment variable PATH

   printf("Loading PATH... ");

   if ((fin = esx_f_open(_ENV_FNAME, ESX_MODE_R | ESX_MODE_OPEN_EXIST)) != 0xff)
   {
      puts(env_getenv(fin, "PATH", PATH, sizeof(PATH) - 1, buffer, sizeof(buffer)) ? "ok\n" : "undefined\n");
      close_open_files();
   }
   else
      puts("missing");

   // -p

   if (flags.option & FLAG_OPTION_PATH)
   {
      puts("\nPath Walk\n");

      p = path_open();

      for (p = path_next(); p; p = path_next())
      {
         user_interaction();
         printf("%s %s\n", esx_f_chdir(p) ? "X" : "O", p);
      }

      path_close();

      puts("\nDone");

      exit(0);
   }

   // name is required

   if (*name == 0)
      exit((int)err_missing_filename);

   // search

   puts("\nSearching...\n");
   qsort(types, sizeof(types)/sizeof(*types), sizeof(*types), sort_type);

   num = 0;
   strcpy(name, p);

   for (p = path_open(); p; p = path_next())
   {
      user_interaction_spin();

      // walk the directory

      if ((fin = esx_f_opendir(p)) != 0xff)
         gin = esx_f_opendir_ex(p, ESX_DIR_USE_LFN);

      if (gin != 0xff)
      {
         first = 1;

         while ((esx_f_readdir(fin, &dirent_sfn) == 1) && (esx_f_readdir(gin, &dirent_lfn) == 1))
         {
            user_interaction_spin();

            if (((dirent_sfn.attr & ESX_DIR_A_DIR) == 0) && ((stricmp(dirent_sfn.name, name) == 0) || glob_fat(dirent_lfn.name, name)))
            {
               // match, check type

               if (tfound = bsearch(basename_ext(dirent_sfn.name), types, sizeof(types)/sizeof(*types), sizeof(*types), find_type))
               {
                  if (first)
                  {
                     first = 0;
                     printf(" \n%s\n\n", p);
                  }

                  printf("%u - %s\n", ++num, dirent_lfn.name);

                  if (((flags.option & FLAG_OPTION_Q) == 0) && (flags.n <= num))
                  {
                     first = 0xff;
                     break;
                  }
               }
            }
         }
      }
      
      close_open_files();

      if (first == 0xff) break;
   }

   path_close();

   // -?

   if (flags.option & FLAG_OPTION_Q)
      exit(0);

   //

   if (first != 0xff)
      exit((int)err_file_not_found);

   if (esx_f_chdir(p))
      exit(errno);

   // -c

   if (flags.option & FLAG_OPTION_CD)
   {
      puts(" \nChanging to directory");
      exit(0);
   }

   // execute

   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);

   (tfound->load)();

   return (int)err_loading_error;
}
