// Set program ORG

#pragma output CRT_ORG_CODE = 0x8184

// Prune stdio to what is needed

#pragma printf = "%s"

// Customize default crt configuration

#pragma output REGISTER_SP = -1            // do not modify SP on startup

#pragma output CLIB_MALLOC_HEAP_SIZE = 0   // do not create a heap for malloc
#pragma output CLIB_STDIO_HEAP_SIZE  = 0   // do not create extra space for opening FILEs

// Use the custom driver instantiation provided in "crt_driver_instantiation.asm.m4"

#pragma output CRT_INCLUDE_DRIVER_INSTANTIATION = 1
