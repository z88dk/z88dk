// rom model compile
// program at address 0, use ram area after display file for variables

#pragma output CRT_ORG_CODE = 0x0000      // program org
#pragma output CRT_ORG_DATA = 0x5b00
#pragma output CRT_ORG_BSS  = -1          // strip bss section from binary

#pragma output CRT_INITIALIZE_BSS = 1     // crt initializes bss at startup

#pragma output CRT_MODEL = 1              // uncompressed rom model compile

// crt initialization

#pragma output REGISTER_SP = 0            // move the stack to the top of memory

#pragma output CRT_ENABLE_EIDI = 0x00     // do not change ei/di state
#pragma output CRT_ON_EXIT     = 0x10001  // halt on exit

#pragma output CRT_INTERRUPT_MODE = -1    // z80 page zero code sets im 1
#pragma output CRT_INTERRUPT_MODE_EXIT = -1

#pragma output CLIB_MALLOC_HEAP_SIZE = 0  // disable malloc heap
#pragma output CLIB_STDIO_HEAP_SIZE  = 0  // disable stdio heap (no files can be opened)
