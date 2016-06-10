; uchar __CALLEE__ *zx_pxy2saddr_callee(uchar xcoord, uchar ycoord, uchar *mask)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_pxy2saddr_callee
PUBLIC _zx_pxy2saddr_callee
PUBLIC ASMDISP_ZX_PXY2SADDR_CALLEE

.zx_pxy2saddr_callee
._zx_pxy2saddr_callee

   pop hl
   pop de
   pop bc
   ex (sp),hl
   ld h,c

.asmentry

   ; enter:  l = pix X 0..255
   ;         h = pix Y 0..191
   ;        de = uchar *mask, if 0 skip mask
   ; exit : hl = screen address
   ;         e = mask
   ; uses : af, b, de, hl
   
   ld a,d
   or e
   jr z, skipmask
   
   ld a,l
   and $07
   ld b,a
   ld a,$80
   jr z, nomaskrotate
   
.rotloop

   rra
   djnz rotloop

.nomaskrotate

   ld (de),a
   ld e,a
   
.skipmask

   ld a,h
   and $07
   or $40
   ld d,a
   ld a,h
   rra
   rra
   rra
   and $18
   or d
   ld d,a

   srl l
   srl l
   srl l
   ld a,h
   rla
   rla
   and $e0
   or l

   ld l,a
   ld h,d
   ret
   
DEFC ASMDISP_ZX_PXY2SADDR_CALLEE = # asmentry - zx_pxy2saddr_callee
