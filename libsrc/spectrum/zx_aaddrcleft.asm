; uchar __FASTCALL__ *zx_aaddrcleft(void *attraddr)
; aralbrec 06.2007

XLIB zx_aaddrcleft

.zx_aaddrcleft

   ; enter : hl = attribute address
   ; exit  : hl = new attribute address left one character with line wrap
   ;         carry if off screen
   
   dec hl
   ld a,h
   cp $58
   ret


