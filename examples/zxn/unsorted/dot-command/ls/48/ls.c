// zcc +zxn -vn -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size ls.c -o ls -subtype=dot -Cz"--clean" -create-app

#pragma output printf = "%s %u %lu"
#pragma output CLIB_EXIT_STACK_SIZE = 1
#pragma output NEXTOS_VERSION = -1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
#include <errno.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>

unsigned char fin = 0xff;

unsigned char *ls_name;
uint32_t      *ls_size;
struct tm      ls_tm;

void ls_date(void)
{
   printf("%04u-%02u-%02u", ls_tm.tm_year + 1900, ls_tm.tm_mon + 1, ls_tm.tm_mday);
}

void ls_dir(void)
{
   ls_date();
   printf("        %s\n", ls_name);
}

void ls_file(void)
{
   ls_date();
   printf(" %6lu %s\n", *ls_size, ls_name);
}

unsigned char old_cpu_speed;

void cleanup(void)
{
   if (fin != 0xff) esx_f_close(fin);
   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
}

int main(int argc, char **argv)
{
   static unsigned char *name;
   static unsigned char cwd[ESX_PATHNAME_MAX + 1];
   
   static struct esx_stat es;
   static struct esx_dirent ed;
   static struct esx_dirent_slice *slice;

   // initialization
   
   old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   
   atexit(cleanup);
   
   // if a filename is not listed use the current working directory
   
   name = strrstrip(strstrip(argv[1]));
   
   if ((argc == 1) || (strcmp(name, ".") == 0))
   {
      if (esx_f_getcwd(cwd) == 0xff) exit(errno);
      name = cwd;
   }
   
   // try to open as a directory
   
   if ((fin = esx_f_opendir(name)) != 0xff)
   {
      // directory

      while (esx_f_readdir(fin, &ed) == 1)
      {
         slice = esx_slice_dirent(&ed);
         
         ls_name = ed.name;
         ls_size = &slice->size;
         
         tm_from_dostm(&ls_tm, &slice->time);
         
         (ed.attr & ESX_DIR_A_DIR) ? ls_dir() : ls_file();
      }
      
      esx_f_close(fin);
      fin = 0xff;
   }
   else
   {
      // file
      
      if (esx_f_stat(name, &es)) exit(errno);
      
      ls_name = name;
      ls_size = &es.size;
      
      tm_from_dostm(&ls_tm, &es.time);
      
      (es.attr & ESX_DIR_A_DIR) ? ls_dir() : ls_file();
   }
   
   return 0;
}
