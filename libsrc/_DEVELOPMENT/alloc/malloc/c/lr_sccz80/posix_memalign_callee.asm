
; int posix_memalign(void **memptr, size_t alignment, size_t size)

XDEF posix_memalign_callee

posix_memalign_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "../../z80/asm_posix_memalign.asm"
