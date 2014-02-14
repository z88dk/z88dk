
; void *_galloc(void *p, int resize)

XLIB _galloc

LIB asm_galloc

_galloc:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   
   jp asm_galloc
