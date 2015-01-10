
; BSD
; void *rawmemchr(const void *mem, int c)

SECTION code_string

PUBLIC rawmemchr

EXTERN asm_rawmemchr

rawmemchr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld a,c
   jp asm_rawmemchr
