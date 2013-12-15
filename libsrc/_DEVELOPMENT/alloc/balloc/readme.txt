
The block memory allocator allocates fixed size blocks from queues holding a linked list of available blocks.  An array of queues is maintained in a "qtbl", with each queue addressed by an integer index.  The user adds available memory to each queue with the ba_addmem() function and is therefore responsible for determining the size of blocks in each queue.  The ba_bestfit() function assumes the queues are ordered in increasing size order and allocates from the first queue it examines that has an available block.

The available blocks in a queue are stored in a singly linked list.  Each allocated block has an overhead of one byte which identifies which queue the block came from.  The minimum block size is therefore three bytes.

void *qtbl[num_queues];   // queue table, initialize to 0

struct block
{
   uint_8 q;              // queue from which block was allocated
   char mem[];            // available memory in block
                          //   the first two bytes are a ptr to the next block
                          //   in the queue when the block is unallocated
};
