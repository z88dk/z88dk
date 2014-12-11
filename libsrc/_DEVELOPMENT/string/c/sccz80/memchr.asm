
; void *memchr(const void *s, int c, size_t n)

SECTION code_string

PUBLIC memchr

EXTERN asm_memchr

memchr:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   ld a,e
   jp asm_memchr
