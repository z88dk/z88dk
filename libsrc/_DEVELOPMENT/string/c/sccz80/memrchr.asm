
; void *memrchr(const void *s, int c, size_t n)

SECTION code_string

PUBLIC memrchr

EXTERN asm_memrchr

memrchr:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   ld a,e
   jp asm_memrchr
