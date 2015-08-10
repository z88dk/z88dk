; uchar __FASTCALL__ *zx_aaddrcdown(void *attraddr)
; Stefano, 2014.12

PUBLIC zx_aaddrcdown
EXTERN HRG_LineStart

.zx_aaddrcdown

; enter : hl = attribute address
; exit  : hl = new attribute address down one character
;         TODO: carry set if off screen

IF FORlambda
   ld de,33
ELSE
   ld de,35
ENDIF
   add hl,de

   ret
