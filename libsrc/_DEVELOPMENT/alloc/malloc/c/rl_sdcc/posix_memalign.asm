
; int posix_memalign(void **memptr, size_t alignment, size_t size)

XDEF posix_memalign

posix_memalign:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_posix_memalign.asm"
