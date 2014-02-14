
; void *_falloc(void *p, size_t size)

XLIB _falloc

LIB asm_falloc

_falloc:

   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   
   jp asm_falloc
