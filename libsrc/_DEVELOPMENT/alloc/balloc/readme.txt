
balloc
======

A block memory allocator that allocates available fixed-size blocks from queues holding a linked list of available blocks.  Allocation and deallocation is very quick.

An array of queues is maintained in a "qtbl", with each queue addressed by an integer index.  The user adds available memory to each queue with the ba_addmem() function and is therefore responsible for determining the size of blocks in each queue.  The ba_bestfit() function assumes the queues are ordered in increasing size order and allocates from the first queue it examines that has an available block.

Each queue is forward_list container.

Each block has an overhead of one byte which identifies which queue the block came from.  The minimum block size is therefore three bytes.
