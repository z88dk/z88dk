
; void free_unlocked_fastcall(void *p)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _free_unlocked_fastcall

EXTERN asm_free_unlocked

defc _free_unlocked_fastcall = asm_free_unlocked
