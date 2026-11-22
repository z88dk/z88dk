#ifndef _MEMORY_H
#define _MEMORY_H

/*
 * NOTE: Pragma DOTN_NUM_EXTRA must be set equal to (NUM_LFN_PAGES + NUM_DIR_PAGES)
 *       in zpragma.inc so that the build allocates those pages on startup.
 *
 *       The physical page numbers are available through _z_extra_table[]
 */

#include <stdint.h>
#include <time.h>
#include <adt/p_queue.h>
#include <alloc/obstack.h>

///////////////
// FILE RECORDS
///////////////

// File record pointers are kept in main memory
// from the end of the program to 0xffff.

extern struct obstack *fob;       // obstack will manage main memory
extern unsigned char fob_blob[];  // address after program in main memory

extern struct file_record_ptr *fbase; // base address of file record ptr array
extern unsigned int fbase_sz;         // number of file records

// file_record_ptr are fixed size and sortable with qsort.

struct file_record;

struct file_record_ptr
{
   unsigned char page;         // lfn page file record is found in
   struct file_record *fr;     // mmu7 pointer to file record
};

// File records describe a directory entry.
// These are stored in paged memory with mmu7 addresses embedded.

#define NUM_LFN_PAGES   4
#define BASE_LFN_PAGES  0

extern unsigned char clob;                  // current obstack being allocated from
extern struct obstack *lob[NUM_LFN_PAGES];  // obstacks will manage memory in each 8k page

#define FILE_RECORD_TYPE_FILE  0
#define FILE_RECORD_TYPE_DIR   1

struct file_record
{
   unsigned char  type;
   struct dos_tm  time;
   uint32_t       size;
   unsigned int   len;         // total length of name
   unsigned char  sfn[13];     // 8.3 filename
   unsigned char  lfn[1];      // lfn name variable size
};

// clear all file records

extern void memory_clear_file_records(void);

////////////////////
// DIRECTORY RECORDS
////////////////////

// Directory records keep track of directories
// that need to be visited for listings

struct dir_record
{
   struct dir_record *next;    // link field needed by p_queue
   unsigned int size;          // size of this struct in bytes
   unsigned char name[1];      // variable size lfn name
};

// Directory records are stored in two 8k pages
// mapped to mmu6 and mmu7.  They consist of a fixed
// size record portion followed by an lfn name.

#define NUM_DIR_PAGES   2
#define BASE_DIR_PAGES  NUM_LFN_PAGES

extern unsigned int dir_start;  // address of first byte of available memory
extern unsigned int dir_end;    // address of last byte of available memory

extern p_queue_t dqueue;        // directory records are stored in a fifo queue

// clear directory queue

extern void memory_clear_dir_queue(void);

//////////
// BANKING
//////////

extern void memory_page_in_mmu6(unsigned char logical_page) __preserves_regs(b,c) __z88dk_fastcall;
extern void memory_page_in_mmu7(unsigned char logical_page) __preserves_regs(b,c) __z88dk_fastcall;

extern void memory_restore_mmu6(void) __preserves_regs(b,c,d,e,h,l);
extern void memory_restore_mmu7(void) __preserves_regs(b,c,d,e,h,l);

extern void memory_page_in_dir(unsigned char logical_page) __preserves_regs(b,c) __z88dk_fastcall;
extern void memory_restore_dir(void) __preserves_regs(b,c,d,e,h,l);

#endif
