#include "move.h"
#include "mv.h"

unsigned char move_classify(unsigned char src_type, unsigned char dst_type)
{
   // src_type has bit 7 set if directory
   // dst_type is FILE_TYPE_UNKNOWN, FILE_TYPE_NORMAL, FILE_TYPE_DIRECTORY
   
   if (src_type & 0x80)
   {
      // src is a directory
      
      if (dst_type == FILE_TYPE_NORMAL)
         return MOVE_DIR_TO_FILE;
      
      if (dst_type == FILE_TYPE_DIRECTORY)
         return MOVE_DIR_TO_DIR;
   }
   else
   {
      // src is a file
      
      if (dst_type == FILE_TYPE_NORMAL)
         return MOVE_FILE_TO_FILE;
      
      if (dst_type == FILE_TYPE_DIRECTORY)
         return MOVE_FILE_TO_DIR;
   }
   
   return MOVE_ERROR;
}
