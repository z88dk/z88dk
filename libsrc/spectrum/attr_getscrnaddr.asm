; 04.2006 aralbrec

; void *attr_getscrnaddr(void *attraddr)

XLIB attr_getscrnaddr

; Convert attribute address to a pixel address corresponding
; to the top pixel scan line in the same character position.
;
; enter : hl = attribute address
; exit  : hl = pixel screen address

.attr_getscrnaddr

   ld a,h
   rla
   rla
   rla
   and $58
   ld h,a
   ret
