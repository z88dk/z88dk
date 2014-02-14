
; void *_falloc_unlocked(void *p, size_t size)

XLIB _falloc_unlocked

LIB asm_falloc_unlocked

_falloc_unlocked:

   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   
   jp asm_falloc_unlocked
