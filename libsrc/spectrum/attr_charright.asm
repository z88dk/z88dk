; 04.2006 aralbrec

; void *attr_charright(void *attraddr)

XLIB attr_charright

; Modify attribute address so that it points at character to the right
;
; enter : hl = attribute address
; exit  : hl = new attribute address, moving right one character

.attr_charright

   inc hl
   ret
