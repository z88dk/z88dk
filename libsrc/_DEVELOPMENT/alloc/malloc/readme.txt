
A heap consists of a linked list of regions, each region being a contiguous block of memory.  The list of regions is kept in increasing address order.

struct region
{
   struct region *next;      // +0 // 0 if no next region in list
   uint_16        size;      // +2 // & region + size = & byte following region
   struct block   blocks[];  // +4 // array of allocation blocks
   void          *terminal;  // +? // last two bytes are NULL == 0
};

Within the region is a linked list of allocation blocks.  During execution, these blocks are packed together like an array and completely occupy the space up to terminal but the number of blocks and size of each block will vary.

Each block is formatted thus:

struct block
{
   struct block  *next;      // +0 // next block in list of blocks (0 if none)
   uint_16        committed; // +2 // & block + committed = & byte following allocation
   struct block  *prev;      // +4 // & prior block in list of blocks (0 if none)
   char           mem[];     // +6 // memory in this block
};

The amount of memory in each block is variable.  Each block represents a memory allocation, however not all the memory in the block may be used.  committed is the sum of allocation size request plus the header size (6).  committed is 0 if the memory in the block is unused, which can only happen for the first block in a region.  The total amount of memory in the block is calculated from (block->next - & block) and the available memory from (block->next - & block - block->committed).
