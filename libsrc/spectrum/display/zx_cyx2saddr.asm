; uchar *zx_cyx2saddr(uchar row, uchar col)
; CALLER linkage for function pointers

XLIB zx_cyx2saddr

LIB zx_cyx2saddr_callee
XREF ASMDISP_ZX_CYX2SADDR_CALLEE

.zx_cyx2saddr

   pop bc
   pop hl
   pop de
   ld h,d
   push de
   push hl
   push bc
   
   jp zx_cyx2saddr_callee + ASMDISP_ZX_CYX2SADDR_CALLEE
