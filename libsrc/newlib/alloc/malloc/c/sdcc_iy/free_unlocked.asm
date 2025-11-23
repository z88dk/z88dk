
; void free_unlocked(void *p)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _free_unlocked

EXTERN asm_free_unlocked

_free_unlocked:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_free_unlocked
