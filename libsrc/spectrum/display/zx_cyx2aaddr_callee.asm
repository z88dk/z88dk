; uchar __CALLEE__ *zx_cyx2aaddr_callee(uchar row, uchar col)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_cyx2aaddr_callee
PUBLIC _zx_cyx2aaddr_callee
PUBLIC ASMDISP_ZX_CYX2AADDR_CALLEE

.zx_cyx2aaddr_callee
._zx_cyx2aaddr_callee

   pop hl
   pop de
   ex (sp),hl
   ld h,l
   ld l,e

.asmentry

   ; h = char Y 0..23
   ; l = char X 0..31

   ld a,h
   rrca
   rrca
   rrca
   ld h,a
   
   and $e0
   or l
   ld l,a
   
   ld a,h
   and $03
   or $58
   ld h,a
   
   ret

DEFC ASMDISP_ZX_CYX2AADDR_CALLEE = # asmentry - zx_cyx2aaddr_callee
