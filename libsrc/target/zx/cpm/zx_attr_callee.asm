; uint __CALLEE__ zx_attr_callee(uchar row, uchar col)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_attr_callee
PUBLIC _zx_attr_callee
PUBLIC ASMDISP_ZX_ATTR_CALLEE

EXTERN zx_cyx2aaddr_callee
EXTERN ASMDISP_ZX_CYX2AADDR_CALLEE

EXTERN p3_peek

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
   call p3_peek
   ld l,a
   ld h,0
   
   ret

DEFC ASMDISP_ZX_ATTR_CALLEE = # asmentry - zx_attr_callee
