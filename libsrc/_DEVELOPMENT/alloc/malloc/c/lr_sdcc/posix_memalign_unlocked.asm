
; int posix_memalign_unlocked(void **memptr, size_t alignment, size_t size)

XDEF posix_memalign_unlocked

posix_memalign_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_posix_memalign_unlocked.asm"
