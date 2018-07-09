#include <stdio.h>
#include <string.h>
#include <libgen.h>
#include <arch/zxn/esxdos.h>

#include "globals.h"
#include "path.h"

struct esx_dirent_lfn dirent;

char *path_parent;
unsigned char constructed_path[ESX_PATHNAME_MAX];

char *path_walk(char *p)
{
   if (p)
   {
      unsigned int len;
      
      path_close();
      len = strlen(p = pathnice(p));
      
      if ((len >= 2) && (stricmp(&p[len - 2], "/*") == 0))
      {
         p[len - 1] = 0;
         path_parent = p;

         fdir = esx_f_opendir_ex(p, ESX_DIR_USE_LFN);
      }
      else
         return pathnice(p);
   }

   if (fdir != 0xff)
   {
      while (esx_f_readdir(fdir, &dirent) == 1)
      {
         if ((dirent.attr & ESX_DIR_A_DIR) && (stricmp(dirent.name, ".") != 0) && (stricmp(dirent.name, "..") != 0))
         {
            snprintf(constructed_path, sizeof(constructed_path), "%s%s", path_parent, pathnice(dirent.name));
            return constructed_path;
         }
      }
   
      path_close();
   }
   
   return 0;
}

char *path_open(void)
{
   unsigned char *p;
   
   if (p = strtok(PATH, ":;"))
      return (p = path_walk(p)) ? p : path_next();

   return 0;
}

char *path_next(void)
{
   unsigned char *p;
   
   if (p = path_walk(0))
      return p;
   
   while (p = strtok(0, ":;"))
      if (p = path_walk(p)) return p;
   
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
