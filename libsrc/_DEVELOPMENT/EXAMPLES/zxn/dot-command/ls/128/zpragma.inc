// Move main bank org to mmu4

#pragma output CRT_ORG_MAIN = 0x8180

// Allocate 384 bytes to the stack underneath the program
// in the main bank.  This keeps it out of the top 16k for
// NextZXOS and it allows the obstack used to hold file records
// to grow to the top of memory so its size can be determined
// at runtime rather than by trial-and-error at compile time.
// The 384 bytes are inside allocated mmu4.

#pragma output REGISTER_SP = 0x8180

// Limit size of printf

#pragma printf = "%s %c %u %lu"

// Room for one atexit function

#pragma output CLIB_EXIT_STACK_SIZE = 1

// Need enough pages to cover main bank in logical->physical table

#pragma output DOTN_LAST_PAGE = 11

// By default z88dk will allocate all main bank pages starting
// from the first occupied at address CRT_ORG_MAIN.  So here
// z88dk will be allocating pages for mmu4 through mmu7 which
// is what we want.

// Request additional pages for file records and dir records
// see memory.h

#pragma output DOTN_NUM_EXTRA = 6

// Load an alternate implementation if NextZXOS is in 48k mode

#pragma output DOTN_ENABLE_ALTERNATE = 1
