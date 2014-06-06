
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRAGMAS THAT APPLY TO ALL TARGETS ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

When these pragmas are present in the C source, they override
the defaults set for a particular target.  The values of the
pragmas (if applicable) have the same meanings.

For pragmas specific to each target, see the readme.txt file
in the target's subdirectory.

nn   =  8-bit number
nnnn = 16-bit number

#pragma output CRT_ORG = nnnn
#pragma output CRT_BSS_SEGMENT_ADDRESS = nnnn
#pragma output CRT_DATA_SEGMENT_ADDRESS = nnnn
#pragma output CRT_DATA_SEGMENT_INIT = nn

#pragma output CLIB_FOPEN_MAX = nn
#pragma output CLIB_EXIT_STACK_SIZE = nn
#pragma output CLIB_QUICKEXIT_STACK_SIZE = nn

#pragma output CLIB_HEAP_SIZE = nnnn
#pragma output CLIB_QTBL_SIZE = nn

#pragma output CONS_EDITBUF_LEN = nn

#pragma output CLIB_ENABLE_LOCALE
#pragma output CLIB_ENABLE_SYSTEM

#pragma output REGISTER_SP = nnnn
