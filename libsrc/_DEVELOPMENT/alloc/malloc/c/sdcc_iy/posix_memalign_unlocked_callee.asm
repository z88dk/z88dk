
; int posix_memalign_unlocked_callee(void **memptr, size_t alignment, size_t size)

SECTION code_alloc_malloc

PUBLIC _posix_memalign_unlocked_callee

_posix_memalign_unlocked_callee:

   pop af
   pop de
   pop bc
   pop hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_posix_memalign_unlocked.asm"
