// zcc +zxn -v -clib=sdcc_iy -SO3 --max-allocs-per-node200000 dir.c -o dir -subtype=nex -Cz"--clean" -create-app
// zcc +zxn -v -clib=new dir.c -o dir -subtype=nex -Cz"--clean" -create-app

#include <stdio.h>
#include <arch/zxn/esxdos.h>
#include <time.h>
#include <errno.h>

#pragma printf = "%B %s %lu %u"

struct esx_dirent_lfn file;
struct tm dt;

unsigned char cwd[ESX_PATHNAME_MAX+1];

void main(void)
{
   unsigned char dirh;
   
   esx_f_getcwd(cwd);
   printf("CWD: %s\n", cwd);
   
   dirh = esx_f_opendir_ex(cwd, ESX_DIR_USE_LFN);
   
   while (esx_f_readdir(dirh, &file) && (errno == 0))
   {
      struct esx_dirent_slice *slice;

      slice = esx_slice_dirent(&file);
      tm_from_dostm(&dt, &slice->time);
      
      printf("\n");
      
      printf("attr: %08B\n", file.attr);
      printf("name: %s\n", file.name);
      printf("size: %lu\n", slice->size);
      printf("date: %02u/%02u/%u\n", dt.tm_mday, dt.tm_mon, dt.tm_year + 1900);
      printf("time: %02u:%02u:%02u\n", dt.tm_hour, dt.tm_min, dt.tm_sec);
      
      printf("\n");
   }
}
