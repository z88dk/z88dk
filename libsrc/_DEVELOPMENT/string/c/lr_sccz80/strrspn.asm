
; size_t strrspn(const char *str, const char *cset)

XLIB strrspn

LIB asm_strrspn

strrspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strrspn
