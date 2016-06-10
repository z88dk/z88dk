; uchar __CALLEE__ *zx_pxy2aaddr_callee(uchar xcoord, uchar ycoord)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_pxy2aaddr_callee
PUBLIC _zx_pxy2aaddr_callee
PUBLIC ASMDISP_ZX_PXY2AADDR_CALLEE

.zx_pxy2aaddr_callee
._zx_pxy2aaddr_callee

   pop hl
   pop de
   ex (sp),hl
   ld h,e
   
.asmentry

   ; enter:  l = pix X 0..255
   ;         h = pix Y 0..191
   ; exit : hl = screen address
   ; uses : af, hl

   srl l
   srl l
   srl l

   ld a,h
   rlca
   rlca
   ld h,a
   
   and $e0
   or l
   ld l,a
   
   ld a,h
   and $03
   or $58
   ld h,a
   
   ret

DEFC ASMDISP_ZX_PXY2AADDR_CALLEE = # asmentry - zx_pxy2aaddr_callee
