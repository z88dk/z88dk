
; size_t strxfrm(char * restrict s1, const char * restrict s2, size_t n)

XLIB strxfrm

LIB asm_strxfrm

strxfrm:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strxfrm
