; uchar __CALLEE__ *zx_cyx2saddr_callee(uchar row, uchar col)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_cyx2saddr_callee
PUBLIC _zx_cyx2saddr_callee
PUBLIC ASMDISP_ZX_CYX2SADDR_CALLEE

.zx_cyx2saddr_callee
._zx_cyx2saddr_callee

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
   and $e0
   or l
   ld l,a
   
   ld a,h
   and $18
   or $40
   ld h,a
   
   ret

DEFC ASMDISP_ZX_CYX2SADDR_CALLEE = # asmentry - zx_cyx2saddr_callee
