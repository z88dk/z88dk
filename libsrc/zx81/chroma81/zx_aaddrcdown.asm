; uchar __FASTCALL__ *zx_aaddrcdown(void *attraddr)
; Stefano, 2014.12

XLIB zx_aaddrcdown
XREF HRG_LineStart

.zx_aaddrcdown

; enter : hl = attribute address
; exit  : hl = new attribute address down one character
;         TODO: carry set if off screen

   ld de,HRG_LineStart+2+32768
   ld hl,35
   add hl,de

   ret
