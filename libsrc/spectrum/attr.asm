; 07.2006 aralbrec

; uchar attr(uchar row, uchar col)
;
; Return attribute occupying character square
; on screen.  Works like the basic command of
; same name.

XLIB attr
LIB attr_getcharaddr

.attr

   call attr_getcharaddr
   ld l,(hl)
   ld h,0
   ret
