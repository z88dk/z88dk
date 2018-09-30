// zcc +zxn -vn -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size ls.c -o ls -subtype=dot -Cz"--clean" -create-app

#pragma output printf = "%s %u %lu"
#pragma output CLIB_EXIT_STACK_SIZE = 1
#pragma output NEXTOS_VERSION = -1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>

unsigned char *name;
unsigned char cwd[ESX_PATHNAME_MAX + 1];

struct tm tms;

struct esx_stat es;

struct esx_dirent ed;
struct esx_dirent_slice *slice;

unsigned char fin = 0xff;

void print_file_info(void)
{
   tm_from_dostm(&tms, &es.time);
   
   if (es.attr & ESX_DIR_A_DIR)
   {
      printf("%-12s %8s %02u.%02u.%04u\n", name, "<DIR>", tms.tm_mday, tms.tm_mon + 1, tms.tm_year + 1900);
   }
   else
   {
      printf("%-12s %8lu %02u.%02u.%04u\n", name, es.size, tms.tm_mday, tms.tm_mon + 1, tms.tm_year + 1900);
   }
}

void print_dirfile_info(void)
{
   tm_from_dostm(&tms, &slice->time);
   
   if (ed.attr & ESX_DIR_A_DIR)
   {
      printf("%-12s %8s %02u.%02u.%04u\n", ed.name, "<DIR>", tms.tm_mday, tms.tm_mon + 1, tms.tm_year + 1900);
   }
   else
   {
      printf("%-12s %8lu %02u.%02u.%04u\n", ed.name, slice->size, tms.tm_mday, tms.tm_mon + 1, tms.tm_year + 1900);
   }
}

unsigned char old_cpu_speed;

void cleanup(void)
{
   if (fin != 0xff) esx_f_close(fin);
   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
}

int main(int argc, char **argv)
{
   // initialization
   
   old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   
   atexit(cleanup);
   
   // if a filename is not listed use the current working directory
   
   name = argv[1];
   
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
         print_dirfile_info();
      }
      
      esx_f_close(fin);
      fin = 0xff;
   }
   else
   {
      // file
      
      if (esx_f_stat(name, &es)) exit(errno);
      print_file_info();
   }
   
   return 0;
}
