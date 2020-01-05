; uchar __FASTCALL__ *zx_aaddrcleft(void *attraddr)
; Stefano, 2014.12

SECTION code_clib
PUBLIC zx_aaddrcleft
PUBLIC _zx_aaddrcleft
EXTERN HRG_LineStart

.zx_aaddrcleft
._zx_aaddrcleft

   ; enter : hl = attribute address
   ; exit  : hl = new attribute address left one character with line wrap
   ;         TODO: carry if off screen
   

   dec hl
;   ld a,h
;   cp $58
   ret


