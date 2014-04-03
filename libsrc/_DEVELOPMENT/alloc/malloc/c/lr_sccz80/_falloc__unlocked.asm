
; void *_falloc__unlocked(void *p, size_t size)

XLIB _falloc__unlocked

LIB asm__falloc_unlocked

_falloc__unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm__falloc_unlocked
