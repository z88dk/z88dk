#include <string.h>
#include <libgen.h>
#include <arch/zxn/esxdos.h>

#include "path.h"
#include "run.h"
#include "user_interaction.h"

unsigned char fdir = 0xff;
struct esx_dirent dirent;

unsigned char *path_walk(unsigned char *p)
{
   static unsigned int len;
   
   p = strstrip(p);
   
   if (p && *p)
   {
      unsigned char *q;
      
      path_close();

      strcpy(buffer, current_drive);

      q = advance_past_drive(p);
      if (p != q) *buffer = *p;
      
      q = pathnice(q);
      if (*q == '/') ++q;
      
      len = strlen(strupr(strcat(buffer, q)));

      if (strcmp(&buffer[len - 2], "/*") == 0)
      {
         buffer[len - 1] = 0;
         fdir = esx_f_opendir(buffer);
      }
      else
         return buffer;
   }

   if (fdir != 0xff)
   {
      while (esx_f_readdir(fdir, &dirent) == 1)
      {
         user_interaction();
         
         if ((dirent.attr & ESX_DIR_A_DIR) && (strcmp(dirent.name, ".") != 0) && (strcmp(dirent.name, "..") != 0))
         {
            strcpy(buffer + len - 1, strupr(dirent.name));
            return buffer;
         }
      }
   
      path_close();
   }
   
   return 0;
}

static unsigned char *tokenize;

char *path_open(void)
{
   tokenize = PATH;
   return cwd;
}

char *path_next(void)
{
   unsigned char *p;

   if (p = path_walk(0))
      return p;

   while (p = strtok(tokenize, ";"))
   {
      tokenize = 0;
      if (p = path_walk(p)) return p;
   }
   
   return 0;
}

void path_close(void)
{
   if (fdir != 0xff)
   {
      esx_f_close(fdir);
      fdir = 0xff;
   }
}
