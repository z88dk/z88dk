#include <alloc/obstack.h>
#include <adt/p_queue.h>

#include "memory.h"

struct obstack *fob;
struct file_record_ptr *fbase;
unsigned int fbase_sz;

unsigned char clob;
struct obstack *lob[NUM_LFN_PAGES];

unsigned int dir_start = 0xc000;
unsigned int dir_end = 0xffff;

p_queue_t dqueue;


// initialize file records to empty

void memory_clear_file_records(void)
{
   // file record pointers in main memory
   
   obstack_free(fob, fbase);
   fbase_sz = 0;

   // file records in page obstacks

   for (unsigned char i = 0; i != NUM_LFN_PAGES; ++i)
   {
      memory_page_in_mmu7(i + BASE_LFN_PAGES);
      lob[i] = obstack_init((void *)0xe000, 0x1fff);
   }
   
   memory_restore_mmu7();
}

// initialize directory queue to empty

void memory_clear_dir_queue(void)
{
   p_queue_init(&dqueue);
}
