// Use main memory starting at 0x8180

#pragma output CRT_ORG_MAIN = 0x8180

// Allocate 384 bytes to the stack underneath the program
// in the main bank.  This allows the data structures used
// to claim all memory after the end of the program.

#pragma output REGISTER_SP = 0x8180

// Alter the ramtop check to 0x8000 for stack space

#pragma output DOTX_RAMTOP = 0x8000

// Indicate this is for NextZXOS 48k+

#pragma output NEXTOS_VERSION = -1

// Limit size of printf

#pragma printf = "%s %c %u"

// Room for one atexit function

#pragma output CLIB_EXIT_STACK_SIZE = 1
