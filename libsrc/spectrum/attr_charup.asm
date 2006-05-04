; 04.2006 aralbrec

; void *attr_charup(void *attraddr)

XLIB attr_charup

; Modify attribute address so that it points at character above
;
; enter : hl = attribute address
; exit  : hl = new attribute address, moving up one character

.attr_charup

   ld a,l
   sub $20
   ld l,a
   ret nc
   dec h
   ret
