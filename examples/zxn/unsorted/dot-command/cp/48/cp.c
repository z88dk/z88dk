// zcc +zxn -vn -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size cp.c errors.asm -o cp -subtype=dot -Cz"--clean" -create-app

#pragma output printf = "%c"
#pragma output CLIB_EXIT_STACK_SIZE = 1
#pragma output NEXTOS_VERSION = -1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <libgen.h>
#include <input.h>
#include <errno.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>

unsigned char fin = 0xff;
unsigned char fout = 0xff;

unsigned char *dst;
unsigned char *src;

unsigned char cwd[ESX_PATHNAME_MAX + ESX_FILENAME_MAX + 2];

unsigned char buffer[512];

unsigned char *advance_past_drive(unsigned char *p)
{
   return (isalpha(p[0]) && (p[1] == ':')) ? (p + 2) : p;
}

static unsigned char cpos;
static unsigned char cursor[] = "-\\|/";

extern unsigned char err_break_into_program[];

void user_interaction_cursor(void)
{
   printf("%c" "\x08", cursor[cpos]);
   if (++cpos >= (sizeof(cursor) - 1)) cpos = 0;

   if (in_key_pressed(IN_KEY_SCANCODE_SPACE | 0x8000))
   {
      puts("<break>");

      in_wait_nokey();
      exit((int)err_break_into_program);
   }
}

unsigned char old_cpu_speed;
unsigned char *delete;

void cleanup(void)
{
   if (fin != 0xff) esx_f_close(fin);
   if (fout != 0xff) esx_f_close(fout);
   
   if (delete) esx_f_unlink(delete);
   
   puts(" ");

   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
}

unsigned char opt_force;

int main(int argc, char **argv)
{
   unsigned int num;
   
   // initialization
   
   old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   
   atexit(cleanup);

   // parse
   
   for (unsigned char i = 1; i != argc; ++i)
   {
      if ((stricmp(argv[i], "-f") == 0) || (stricmp(argv[i], "--force") == 0))
         opt_force = 1;
      else
      {
         if (src == 0)
            src = argv[i];
         else if (dst == 0)
            dst = argv[i];
         else
         {
            dst = 0;
            break;
         }
      }
   }

   // help message
   
   if ((src == 0) || (dst == 0))
   {
      printf("cp - copy files\n\n"
             "cp SRC DST\n"
             "cp SRC DIR\n\n"
             "-f, --force\n"
             "  force overwrite if DST exists\n\n"
             "v1.0 zx-next 48k z88dk.org\n");
      exit(0);
   }
   
   // SRC must be a file
   
   if ((fin = esx_f_open(src, ESX_MODE_OPEN_EXIST | ESX_MODE_R)) == 0xff)
      exit(errno);
   
   // DST can be a file or directory
   
   if (strcmp(dst, ".") == 0)
   {
      if (esx_f_getcwd(cwd) == 0xff) exit(errno);
      dst = cwd;
   }
   
   // if DST is a directory form a new filename
   
   if ((fout = esx_f_opendir(dst)) != 0xff)
   {
      // directory
      
      esx_f_close(fout);
      fout = 0xff;
      
      // form filename
      
      strcpy(cwd, dst);
      strcat(cwd, "/");
      strcat(cwd, basename(advance_past_drive(src)));
      dst = cwd;
   }

   // copy file
   
   if ((fout = esx_f_open(dst, opt_force ? (ESX_MODE_OPEN_CREAT_TRUNC | ESX_MODE_W) : (ESX_MODE_OPEN_CREAT_NOEXIST | ESX_MODE_W))) == 0xff)
      exit(errno);
   
   delete = dst;
   
   while (num = esx_f_read(fin, buffer, sizeof(buffer)))
   {
      user_interaction_cursor();
      
      if (esx_f_write(fout, buffer, num) != num)
         exit(errno);
   }
   
   delete = 0;
   
   // files closed on exit
   
   return 0;
}
