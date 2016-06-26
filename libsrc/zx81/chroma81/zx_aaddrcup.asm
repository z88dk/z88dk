; uchar __FASTCALL__ *zx_aaddrcup(void *attraddr)
; Stefano, 2014.12

SECTION code_clib
PUBLIC zx_aaddrcup
PUBLIC _zx_aaddrcup
EXTERN HRG_LineStart

.zx_aaddrcup
._zx_aaddrcup

; enter : hl = valid attribute address
; exit  : hl = new attribute address up one character
;         TODO: carry set if off screen

IF FORlambda
   ld de,33
ELSE
   ld de,35
ENDIF
   and a
   sbc hl,de

   ret
