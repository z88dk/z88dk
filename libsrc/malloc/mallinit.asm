; void mallinit(void)
; 12.2006 aralbrec

XLIB mallinit
XREF _heap

.mallinit

   ld hl,0
   ld (_heap),hl
   ret
