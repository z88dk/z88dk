/*
 * Run program with PATH search
 * aralbrec @ z88dk.org
*/

// zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o run -pragma-include:zpragma.inc -subtype=dot -Cz"--clean" -create-app
// zcc +zxn -v -startup=30 -clib=new @zproject.lst -o run -pragma-include:zpragma.inc -subtype=dot -Cz"--clean" -create-app

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <ctype.h>
#include <errno.h>
#include <arch/zxn/esxdos.h>
#include <compress/zx7.h>

#include "globals.h"
#include "load.h"
#include "option.h"
#include "path.h"

//////////
// OPTIONS
//////////

#define OPT_FLAG_QQ  0x01
#define OPT_FLAG_P   0x02
#define OPT_FLAG_B   0x04
#define OPT_FLAG_I   0x08
#define OPT_FLAG_R   0x10
#define OPT_FLAG_C   0x20

unsigned char opt_flag = 0;
unsigned char opt_n = 0;

struct opt
{
   unsigned char *name;
   unsigned char  flag;
};

struct opt option[] = {
   { "-?", OPT_FLAG_QQ | OPT_FLAG_R },
   { "-p", OPT_FLAG_P | OPT_FLAG_R },
   { "--path", OPT_FLAG_P | OPT_FLAG_R },
   { "-l", OPT_FLAG_B | OPT_FLAG_R },
   { "--list", OPT_FLAG_B | OPT_FLAG_R },
   { "-i", OPT_FLAG_I | OPT_FLAG_R },
   { "--info", OPT_FLAG_I | OPT_FLAG_R},
   { "-r", OPT_FLAG_R },
   { "-c", OPT_FLAG_C },
   { "--cd", OPT_FLAG_C },
};

/////////////
// FILE TYPES
/////////////

struct ptype
{
   unsigned char *ext;
   void (*load)(void);
};

struct ptype types[] = {
   { ".tap", load_tap },
   { ".sna", load_snap },
   { ".snx", load_snap },
   { ".z80", load_snap },
   { ".o", load_snap },
   { ".p", load_snap },
   { ".nex", load_nex },
   { ".exe", load_exe },
};

struct ptype *program_type;

// qsort types array

int sort_type(struct ptype *a, struct ptype *b)
{
   return stricmp(a->ext, b->ext);
}

// bsearch types array on extension

int find_type(char *ext, struct ptype *a)
{
   return stricmp(ext, a->ext);
}

///////////////////////////
// USAGE INFORMATION (TEXT)
///////////////////////////

extern unsigned char usage[];

///////////////////////////////////////////
// LOCATION OF GLOBAL ENVIRONMENT VARIABLES
///////////////////////////////////////////

extern unsigned char _ENV_FNAME[];

////////////
// FUNCTIONS
////////////

int error(char *s)
{
   esx_f_chdir(cwd);

   s[strlen(s)-1] += 0x80;  
   return (int)s;
}

unsigned char *parse_options(unsigned char *cl)
{
   unsigned char *p;
   
   p = cl;
   
   while (*(p = strstrip(p)))
   {
      // options list
      
      for (unsigned char i = 0; i != sizeof(option)/sizeof(*option); ++i)
      {
         unsigned int len;
            
         len = strlen(option[i].name);
            
         if ((strncmp(option[i].name, p, len) == 0) && (isspace(p[len]) || (p[len] == 0)))
         {
            p += len;
            opt_flag |= option[i].flag;
            
            goto another;
         }
      }
      
      // -n
      
      if ((*p == '-') && !isspace(*(p + 1)))
      {
         unsigned int val;
         unsigned char *end;
         
         errno = 0;
      
         if (((val = _strtou_(p + 1, &end, 0)) <= 255) && (errno == 0))
         {
            opt_n = val;
            p = end;
            
            goto another;
         }
      }
      
      // unrecognized
      
      break;

another:

   }
   
   return p;
}

unsigned char *parse_filename(unsigned char *cl)
{
   unsigned char quote;
   unsigned char *p, *q;
   
   p = strstrip(cl);

   if ((*p == '\'') || (*p == '"'))
      quote = *p++;
   else
      quote = 0;

   for (q = program_name; *p && ((q - program_name) != (sizeof(program_name) - 5)); ++p)
   {
      // quoting
      
      if (*p == quote)
      {
         ++p;
         break;
      }
            
      // part of filename
      
      if ((quote == 0) && isspace(*p))
         break;
      
      *q++ = *p;
   }
         
   if (*p && !isspace(*p))
      exit(error("F Invalid file name"));

   *q = 0;

   return p;
}

void cleanup(void)
{
   if (fin != 0xff) esx_f_close(fin);
   if (fdir != 0xff) esx_f_close(fdir);

   if ((opt_flag & (OPT_FLAG_R | OPT_FLAG_C)) == OPT_FLAG_R) esx_f_chdir(cwd);

   // must make the decision here if it
   // is safe to return to basic; if not
   // perform a soft reset
   
   printf("\n");
}

extern unsigned char *fix_command_line(char *s) __z88dk_fastcall;

int main(unsigned int no, unsigned char *cl)
{
   unsigned char *p;

   // record initial state
   
   if (esx_f_getcwd(cwd))
      strcpy(cwd, "/");

   // clean up on exit
   
   atexit(cleanup);

   p = fix_command_line(cl);

   // parse options from an unprocessed command line
   
   p = parse_options(p);

   // filename with weak quoting
   
   p = parse_filename(p);
   command_line = cl + (p - PATH);

   // what are we doing ?

   // print usage if no options and no filename given
   
   if ((opt_flag == 0) && (program_name[0] == 0))
   {
      *dzx7_standard(usage, PATH) = 0;   // PATH is 512 bytes so ok to decompress there
      printf("\n%s", PATH);
      exit(0);
   }
   
   printf("\nFilename... %s\n", program_name[0] ? basename(program_name) : "<none>");

   // read PATH
   
   printf("Loading PATH... ");
   
   PATH[0] = 0;

   if ((fin = esx_f_open(_ENV_FNAME, ESX_MODE_R | ESX_MODE_OPEN_EXIST)) != 0xff)
   {
      printf("%s\n", env_getenv(fin, "PATH", PATH, sizeof(PATH) - 1, buf, sizeof(buf)) ? "ok\n" : "undefined\n");

      esx_f_close(fin);
      fin = 0xff;
   }
   else
      printf("fail\n");
   
   // -p

   if (opt_flag & OPT_FLAG_P)
   {
      option_print_path();
      exit(0);
   }

   // program is required
   
   if (program_name[0] == 0)
      exit(error("F Missing file name"));
   
   // -?
   
   if (opt_flag & OPT_FLAG_QQ)
   {
      option_print_find_dirs();
      exit(0);
   }

   // find the program
   
   printf("Searching...\n");
   
   if (opt_n == 0)
   {
      if ((fin = esx_f_open(program_name, ESX_MODE_R | ESX_MODE_OPEN_EXIST)) != 0xff)
         strcpy(PATH, program_name);
   }
   
   if (fin == 0xff)
   {
      if (opt_n == 0) opt_n = 1;
      
      for (p = path_open(); p != 0; p = path_next())
      {
         esx_f_chdir("/");
         if ((*p == 0) || esx_f_chdir(p)) continue;
         
         if ((fin = esx_f_open(basename(program_name), ESX_MODE_R | ESX_MODE_OPEN_EXIST)) != 0xff)
         {
            printf("+ %s\n", p);
            
            if (--opt_n == 0)
            {
               strcpy(PATH, p);
               strcat(PATH, "/");
               strcat(PATH, basename(program_name));
               break;
            }
            
            esx_f_close(fin);
            fin = 0xff;
         }
      }
   }

   path_close();

   if (fin == 0xff)
      exit(error("F File not found"));
   
   printf("\nFound:\n%s\n", PATH);

   // -c
   
   if (opt_flag & OPT_FLAG_C)
   {
      printf("\nChanging directory\n");
      exit(0);
   }

   // check extension of filename
   
   program_type = 0;
   qsort(types, sizeof(types)/sizeof(*types), sizeof(*types), sort_type);
   
   while ((p = strrchr(program_name, '.')) == 0)
      strcat(program_name, ".exe");

   program_type = bsearch(p, types, sizeof(types)/sizeof(*types), sizeof(*types), find_type);

   if (program_type == 0)
      exit(error("F Unknown file type"));

   // load program

   if (stricmp(program_type->ext, ".exe") != 0)
   {
      esx_f_close(fin);
      fin = 0xff;
   }

   (program_type->load)();
   
   return error("R Loading error");
}
