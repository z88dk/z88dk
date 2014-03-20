
; void *_falloc_unlocked(void *p, size_t size)

XLIB _falloc_unlocked

LIB asm__falloc_unlocked

_falloc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm__falloc_unlocked
