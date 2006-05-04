; 04.2006 aralbrec

; void *attr_chardown(void *attraddr)

XLIB attr_chardown

; Modify attribute address so that it points at character below
;
; enter : hl = attribute address
; exit  : hl = new attribute address, moving down one character

.attr_chardown

   ld a,l
   add a,$20
   ld l,a
   ret nc
   inc h
   ret
