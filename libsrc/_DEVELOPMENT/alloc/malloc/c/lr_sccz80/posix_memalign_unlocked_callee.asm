
; int posix_memalign_unlocked(void **memptr, size_t alignment, size_t size)

PUBLIC posix_memalign_unlocked_callee

posix_memalign_unlocked_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_posix_memalign_unlocked.asm"
