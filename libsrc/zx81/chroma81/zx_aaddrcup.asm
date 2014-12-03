; uchar __FASTCALL__ *zx_aaddrcup(void *attraddr)
; Stefano, 2014.12

XLIB zx_aaddrcup
XREF HRG_LineStart

.zx_aaddrcup

; enter : hl = valid attribute address
; exit  : hl = new attribute address up one character
;         TODO: carry set if off screen

   ld hl,HRG_LineStart+2+32768
   ld de,35
   and a
   sbc hl,de

   ret
