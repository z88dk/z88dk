; void mallinit(void)
; 12.2006 aralbrec

XLIB mallinit

LIB l_setmem
XREF _heap

.mallinit

   xor a
   ld hl,_heap
   jp l_setmem - 7           ; four bytes: 2*4-1
