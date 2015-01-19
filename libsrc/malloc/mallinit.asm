; void mallinit(void)
; 12.2006 aralbrec

PUBLIC mallinit

EXTERN l_setmem
EXTERN _heap

.mallinit

   xor a
   ld hl,_heap
   jp l_setmem - 7           ; four bytes: 2*4-1
