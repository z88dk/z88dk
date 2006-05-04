; 04.2006 aralbrec

; void *attr_charleft(void *attraddr)

XLIB attr_charleft

; Modify attribute address so that it points at character to the left
;
; enter : hl = attribute address
; exit  : hl = new attribute address, moving left one character

.attr_charleft

   dec hl
   ret
