
; int posix_memalign_unlocked(void **memptr, size_t alignment, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _posix_memalign_unlocked

EXTERN asm_posix_memalign_unlocked

_posix_memalign_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_posix_memalign_unlocked
