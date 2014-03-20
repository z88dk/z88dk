
; int posix_memalign(void **memptr, size_t alignment, size_t size)

XDEF posix_memalign

posix_memalign:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_posix_memalign.asm"
