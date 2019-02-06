; uchar *zx_cyx2aaddr(uchar row, uchar col)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_cyx2aaddr
PUBLIC _zx_cyx2aaddr

EXTERN zx_cyx2aaddr_callee
EXTERN ASMDISP_ZX_CYX2AADDR_CALLEE

.zx_cyx2aaddr
._zx_cyx2aaddr

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   ld h,e
   jp zx_cyx2aaddr_callee + ASMDISP_ZX_CYX2AADDR_CALLEE
