
; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)

SECTION code_clib
SECTION code_string

PUBLIC _memmem

EXTERN asm_memmem

_memmem:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push hl
   push af

   jp asm_memmem
