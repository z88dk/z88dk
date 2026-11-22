// COMPILE TIME CRT CONFIGURATION

#pragma output CRT_ORG_CODE           = 25124      // org of compile
#pragma output REGISTER_SP            = 0xd000     // typical stack location when using sp1

#pragma output CRT_ENABLE_CLOSE       = 0          // don't bother closing files on exit
#pragma output CRT_ENABLE_EIDI        = 0x1        // disable interrupts at start
#pragma output CRT_ON_EXIT            = 0x30002    // return to basic on exit

#pragma output CLIB_MALLOC_HEAP_SIZE  = 0          // no malloc heap
#pragma output CLIB_STDIO_HEAP_SIZE   = 0          // no stdio heap (no files)

#pragma output CLIB_FOPEN_MAX         = -1         // no FILE* list
#pragma output CLIB_OPEN_MAX          = -1         // no fd table

// CREATE A BLOCK MEMORY ALLOCATOR WITH ONE QUEUE

#pragma output CLIB_BALLOC_TABLE_SIZE = 1
