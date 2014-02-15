
; size_t strrcspn(const char *str, const char *cset)

XLIB strrcspn

LIB asm_strrcspn

strrcspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strrcspn
