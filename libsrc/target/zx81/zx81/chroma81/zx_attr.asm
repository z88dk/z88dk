; uint zx_attr(uchar row, uchar col)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_attr
PUBLIC _zx_attr

EXTERN zx_attr_callee
EXTERN ASMDISP_ZX_ATTR_CALLEE

.zx_attr
._zx_attr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   ld h,l
   ld l,e
   jp zx_attr_callee + ASMDISP_ZX_ATTR_CALLEE
