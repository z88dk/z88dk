; uint __CALLEE__ attr_callee(uchar row, uchar col)
; aralbrec 06.2007

XLIB attr_callee
XDEF ASMDISP_ATTR_CALLEE

LIB zx_cyx2aaddr_callee
XREF ASMDISP_ZX_CYX2AADDR_CALLEE

.attr_callee

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

DEFC ASMDISP_ATTR_CALLEE = asmentry - attr_callee
