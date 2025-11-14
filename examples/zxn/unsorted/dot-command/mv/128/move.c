#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libgen.h>
#include <time.h>
#include <alloc/obstack.h>
#include <arch/zxn/esxdos.h>
#include <errno.h>

#define NONONO

#include "errors.h"
#include "move.h"
#include "mv.h"
#include "user_interaction.h"

unsigned char fin = 0xff;
unsigned char fout = 0xff;

struct esx_stat stat;

struct file_info msrc;
struct file_info mdst;

unsigned char move_classify(unsigned char src_type, unsigned char dst_type)
{   
   if (src_type == FILE_TYPE_DIRECTORY)
   {
      // src is a directory
      
      if (dst_type == FILE_TYPE_NORMAL)
         return MOVE_TYPE_DIR_TO_FILE;
      
      if (dst_type == FILE_TYPE_DIRECTORY)
         return MOVE_TYPE_DIR_TO_DIR;
   }
   else
   {
      // src is a file
      
      if (dst_type == FILE_TYPE_NORMAL)
         return MOVE_TYPE_FILE_TO_FILE;
      
      if (dst_type == FILE_TYPE_DIRECTORY)
         return MOVE_TYPE_FILE_TO_DIR;
   }
   
   return MOVE_TYPE_ERROR;
}

static unsigned char mv_rename_file(char *src, char *dst)
{
   // fail if exists (ie will not overwrite)
   // return 0x00 to mean success

   unsigned char ret;
   
   if (get_drive(src) == get_drive(dst))
   {
      // move on same drive
      
      if ((ret = esx_f_rename(src, dst)) && (ret == 18))
         ret = MOVE_ERROR_FILE_EXISTS;
   }
   else
   {
      // move across drives
      
      unsigned char *buffer;

      // get buffer
      
      if ((buffer = obstack_alloc(ob, 512)) == 0)
      {
         puts("Buffer not available");
         return MOVE_ERROR_BUFFER_UNAVAILABLE;
      }
      
      // open files

      fin = esx_f_open(src, ESX_MODE_OPEN_EXIST | ESX_MODE_READ);
      
      if ((fout = esx_f_open(dst, ESX_MODE_OPEN_CREAT_NOEXIST | ESX_MODE_WRITE)) == 0xff)
         ret = MOVE_ERROR_FILE_EXISTS;
      else
         ret = errno;
      
      if (errno == 0)
      {
         unsigned int num;
         
         // ensure removal of dst file if user breaks
         
         cleanup_remove_name = dst;

         // file copy
         
         while (num = esx_f_read(fin, buffer, 512))
         {
            user_interaction_spin();
            
            if (esx_f_write(fout, buffer, num) != num)
               break;
         }
         
         cleanup_remove_name = 0;
         close_open_files();
         
         if (ret = errno)
         {
            puts("Copy to DST failed");
            esx_f_unlink(dst);
         }
         else
         {
            // remove original file
            
            esx_f_unlink(src);
            
            if (ret = errno)
               puts("Removal of SRC failed");
         }
      }

      close_open_files();
      obstack_free(ob, buffer);
   }

   return ret;
}

unsigned char move_file_to_file(struct file_info *src, struct file_info *dst)
{
   // src exists, dst is known to exist or not

   // copy to static memory to improve code generation
   
   memcpy(&msrc, src, sizeof(msrc));
   memcpy(&mdst, dst, sizeof(mdst));
   
   if (mdst.exists)
   {
      // watch for self-copy
      
      if (get_drive(msrc.name) == get_drive(mdst.name))
      {
         errno = 0;
         
         // rely on operating system to detect multiple opens of same file
         
         fin = esx_f_open(msrc.name, ESX_MODE_OPEN_EXIST | ESX_MODE_READ);
         fout = esx_f_open(mdst.name, ESX_MODE_OPEN_EXIST | ESX_MODE_WRITE);
         
         close_open_files();
         
         if (errno)
         {
            puts("Self-copy disqualified");
            return MOVE_ERROR_SELF_COPY;
         }
      }
      
      // check if overwrite mode is no
      
      if (flags.overwrite == FLAG_OVERWRITE_NO)
      {
         if (flags.verbose)
            puts("Overwrite not allowed");
         
         return 0;
      }
      
      // check timestamp
      
      if (flags.update && (compare_dostm(&msrc.time, &mdst.time) <= 0))
      {
         if (flags.verbose)
            puts("Move disqualified due to date");

         return 0;
      }
      
      // check if overwrite mode is ask
      
      if (flags.overwrite == FLAG_OVERWRITE_ASK)
      {
         printf("Overwrite \"%s\" (y/n) ? _" "\x08", mdst.name);
         if (user_interaction_yn() == 0) return 0;
      }
      
      // check if making backup
      
      if (flags.backup)
      {
         unsigned char ret;
         unsigned char *backup;
         
         // form backup name

         if ((backup = obstack_alloc(ob, strlen(mdst.name) + strlen(flags.suffix) + 2)) == 0)
            exit((int)err_out_of_memory);
         
         sprintf(backup, "%s.%s", mdst.name, flags.suffix);
         
         if (flags.verbose)
            printf("Creating backup \"%s\"\n", backup);

         // check if old backup already exists
         
         if (ret = mv_rename_file(mdst.name, backup))
         {
            if (ret == MOVE_ERROR_FILE_EXISTS)
            {
               if (flags.overwrite == FLAG_OVERWRITE_ASK)
               {
                  printf("Overwrite backup \"%s\" (y/n) ? _" "\x08", backup);
                  if (user_interaction_yn() == 0) return 0;
               }
            
               if (esx_f_unlink(backup))
               {
                  puts("Can't remove old backup");
                  return 0;                  
               }
               
               mv_rename_file(mdst.name, backup);
            }
            else
            {
               puts("Can't create backup");
               return 0;
            }
         }

         obstack_free(ob, backup);
      }
      else
      {
      
         // remove the existing destination file
      
         if (esx_f_unlink(mdst.name))
         {
            puts("Unable to remove DST");
            return MOVE_ERROR_CANNOT_REMOVE;
         }
      }
   }

   return mv_rename_file(msrc.name, mdst.name);
}

unsigned char move_file_to_dir(struct file_info *src, struct file_info *dst)
{
   static struct file_info new;
   unsigned char ret;

   // src exists, dst exists

   // fill in new structure
   
   memset(&new, 0, sizeof(new));
   
   if (new.name = obstack_alloc(ob, strlen(dst->name) + strlen(basename(src->name)) + 2))
   {
      sprintf(new.name, "%s/%s", dst->name, basename(src->name));
      new.type = FILE_TYPE_NORMAL;
      
      if (flags.verbose)
         printf("DST is \"%s\"\n", new.name);
      
      // we must know if the new file exists

      if (esx_f_stat(new.name, &stat) == 0)
      {
         memcpy(&new.time, &stat.time, sizeof(new.time));
         new.exists = 1;
         
         if (stat.attr & ESX_DIR_A_DIR)
         {
            puts("DST is a directory");
            
            obstack_free(ob, new.name);
            return MOVE_ERROR_FILE_IS_DIR;
         }
      }

      // perform the move

      ret = move_file_to_file(src, &new);

      obstack_free(ob, new.name);
   }
   else
   {
      puts("Can't construct DST name");
      return MOVE_ERROR_BUFFER_UNAVAILABLE;
   }

   return ret;
}

unsigned char move_dir_to_dir(struct file_info *src, struct file_info *dst)
{
   // src exists, dst is known to exist or not
   // disqualify child-parent relationships

   // TO-DO: Complete this properly
   
   if (esx_f_rename(src->name, dst->name))
      puts("Not supported in this version");

   return 0;
}
