; uchar __FASTCALL__ *zx_cy2aaddr(uchar row)
; Stefano, 2014.12

PUBLIC zx_cy2aaddr
EXTERN HRG_LineStart

.zx_cy2aaddr

   ld a,l
;   rra
;   rra
;   rra
   and $1f
   ld b,a
   ld hl,HRG_LineStart+2+32768
   jr z,zrow
   ld de,35
.rloop
   add hl,de
   djnz rloop
.zrow

   ret
