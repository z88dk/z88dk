
; void *_galloc_unlocked(void *p, int resize)

XLIB _galloc_unlocked

LIB asm_galloc_unlocked

_galloc_unlocked:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   
   jp asm_galloc_unlocked
