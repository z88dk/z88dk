// Move main bank org to mmu4

#pragma output CRT_ORG_MAIN = 0x8180

// Allocate 384 bytes to the stack underneath the program
// in the main bank.  This allows the data structures used
// to claim all memory after the end of the program.
// The 384 bytes are inside allocated mmu4.

#pragma output REGISTER_SP = 0x8180

// Limit size of printf

#pragma printf = "%s %c %u"

// Room for one atexit function

#pragma output CLIB_EXIT_STACK_SIZE = 1

// Need enough pages to cover main bank in logical->physical table

#pragma output DOTN_LAST_PAGE = 11

// By default z88dk will allocate all main bank pages starting
// from the first occupied at address CRT_ORG_MAIN.  So here
// z88dk will be allocating pages for mmu4 through mmu7 which
// is what we want.

// Load an alternate implementation if NextZXOS is in 48k mode

#pragma output DOTN_ENABLE_ALTERNATE = 1
