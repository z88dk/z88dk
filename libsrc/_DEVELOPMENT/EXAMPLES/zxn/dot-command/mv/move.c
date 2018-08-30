#include <stdio.h>
#include <arch/zxn/esxdos.h>

#include "move.h"
#include "mv.h"

extern struct esx_lfn lfn;

unsigned char move_classify(unsigned char src_type, unsigned char dst_type)
{
   // src_type has bit 7 set if directory
   // dst_type is FILE_TYPE_UNKNOWN, FILE_TYPE_NORMAL, FILE_TYPE_DIRECTORY
   
   if (src_type & 0x80)
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

unsigned char move_file_to_file(void)
{
   printf("Moving file \"%s\" to file \"%s\"\n", lfn.filename, dst.name);
   return 0;
}

unsigned char move_file_to_dir(void)
{
   printf("Moving file \"%s\" to dir \"%s\"\n", lfn.filename, dst.name);
   return 0;
}

unsigned char move_dir_to_dir(void)
{
   printf("Moving dir \"%s\" to dir \"%s\"\n", lfn.filename, dst.name);
   return 0;
}
