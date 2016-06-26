; uint __CALLEE__ zx_attr_callee(uchar row, uchar col)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_attr_callee
PUBLIC _zx_attr_callee
PUBLIC ASMDISP_ZX_ATTR_CALLEE

EXTERN zx_cyx2aaddr_callee
EXTERN ASMDISP_ZX_CYX2AADDR_CALLEE

.zx_attr_callee
._zx_attr_callee

   pop hl
   pop de
   ex (sp),hl
   ld h,l
   ld l,e
   
.asmentry

   ; h = char Y 0..23
   ; l = char X 0..31
   
   call zx_cyx2aaddr_callee + ASMDISP_ZX_CYX2AADDR_CALLEE
   ld l,(hl)
   ld h,0
   
   ret

DEFC ASMDISP_ZX_ATTR_CALLEE = # asmentry - zx_attr_callee
