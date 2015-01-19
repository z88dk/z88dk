; uchar __FASTCALL__ *zx_aaddrcup(void *attraddr)
; aralbrec 06.2007

PUBLIC zx_aaddrcup

.zx_aaddrcup

; enter : hl = valid attribute address
; exit  : hl = new attribute address up one character
;         carry if off screen

   ld a,l
   sub $20
   ld l,a
   ret nc
   dec h
   
   ld a,h
   cp $58
   ret
