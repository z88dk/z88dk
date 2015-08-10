; uchar __FASTCALL__ *zx_aaddrcleft(void *attraddr)
; Stefano, 2014.12

PUBLIC zx_aaddrcleft
EXTERN HRG_LineStart

.zx_aaddrcleft

   ; enter : hl = attribute address
   ; exit  : hl = new attribute address left one character with line wrap
   ;         TODO: carry if off screen
   

   dec hl
;   ld a,h
;   cp $58
   ret


