#ifndef _DIRECTORY_H
#define _DIRECTORY_H

#include <adt/p_queue.h>

// Data

struct dir_record
{
   struct dir_record *next;    // link field needed by p_queue
   unsigned int size;          // size of this struct in bytes
   unsigned char level;        // directory level from starting directory
   unsigned char path[1];      // variable size path in canonical form
};

extern unsigned char *dir_start;  // address of first byte of circular buffer
extern unsigned char *dir_end;    // address of last byte of circular buffer

extern p_queue_t dir_queue;    // directory records are stored in FIFO order inside the buffer

// Functions

extern void directory_clear_queue(void);
extern void directory_add(unsigned char *name, unsigned char level);

#endif
