// move main bank org to mmu3

#pragma output CRT_ORG_MAIN = 0x6180

// allocate 384 bytes to the stack underneath the program
// in the main bank inside mmu3

#pragma output REGISTER_SP = 0x6180

// limit the size of printf

#pragma printf = "%s %u %lu"

// room for one exit function

#pragma output CLIB_EXIT_STACK_SIZE = 1

// Need enough pages to cover main bank in logical->physical table

#pragma output DOTN_LAST_PAGE = 11

// By default z88dk will allocate all main bank pages starting
// from the first occupied at address CRT_ORG_MAIN.  So here
// z88dk will be allocating pages for mmu3 through mmu7 which
// is what we want.

// load an alternate implementation if NextZXOS is in 48k mode

#pragma output DOTN_ENABLE_ALTERNATE = 1
