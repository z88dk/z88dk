; uchar *zx_cyx2saddr(uchar row, uchar col)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_cyx2saddr
PUBLIC _zx_cyx2saddr

EXTERN zx_cyx2saddr_callee
EXTERN ASMDISP_ZX_CYX2SADDR_CALLEE

.zx_cyx2saddr
._zx_cyx2saddr

   pop bc
   pop hl
   pop de
   ld h,d
   push de
   push hl
   push bc
   
   jp zx_cyx2saddr_callee + ASMDISP_ZX_CYX2SADDR_CALLEE
