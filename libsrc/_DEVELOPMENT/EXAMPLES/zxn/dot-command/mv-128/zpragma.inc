// limit size of printf

#pragma printf = "%s %c %u %x"

// room for one atexit function

#pragma output CLIB_EXIT_STACK_SIZE = 1

// COMPILE SHOWS DOTN OCCUPIES MMU 4 & 5

// need enough pages to cover main bank in logical->physical table

#pragma output DOTN_LAST_PAGE = 11

// do not allocate pages for mmu 6 & 7
// (z88dk will allocate from main org to end of memory by default)

#pragma output DOTN_MAIN_ABSOLUTE_MASK = 0xc0

// stack must be kept out of top 16k for NextZXOS
// place it at top of mmu 5

#pragma output REGISTER_SP = 0xbf00

// load an alternate implementation if NextZXOS is in 48k mode

#pragma output DOTN_ENABLE_ALTERNATE = 1
