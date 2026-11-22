#include <stdio.h>
#include <string.h>
#include <adt/p_queue.h>

#include "directory.h"

unsigned char *dir_start;
unsigned char *dir_end;

p_queue_t dir_queue;

void directory_clear_queue(void)
{
   p_queue_init(&dir_queue);
}

void directory_add(unsigned char *name, unsigned char level)
{
   int size;

   static struct dir_record *first;
   static struct dir_record *last;
   static struct dir_record *next;
   static struct dir_record *spot;
   
   // compute size of directory entry
   // (space for zero terminator built into struct dir_record)
   
   size = strlen(name) + sizeof(struct dir_record);
   
   // allocate a spot in the circular buffer if we can
   
   spot = 0;
   
   if ((first = p_queue_front(&dir_queue)) == 0)
   {
      // the directory queue is empty
      // assume one directory entry will always fit
      
      spot = (struct dir_record *)dir_start;
   }
   else
   {
      // the directory queue is not empty
      
      last = p_queue_back(&dir_queue);
      next = (struct dir_record *)((unsigned char *)last + last->size);
      
      if (first <= last)
      {         
         if ((next >= last) && (((unsigned char *)dir_end - (unsigned char *)next) >= size))
            spot = next;
      }
      
      if (spot == 0)
      {
         if (first <= last)
         {
            next = (struct dir_record *)dir_start;
            last = next;
         }
         
         if ((next >= last) && (((unsigned char *)first - (unsigned char *)next) >= size))
            spot = next;
      }
   }

   // insert into directory queue
   
   if (spot)
   {
      spot->size = size;
      spot->level = level;
      strcpy(spot->path, name);
      
      p_queue_push(&dir_queue, spot);
   }
   else
      printf("     \nskipped dir %s\n", name);

   return;
}
