; uchar *zx_pxy2aaddr(uchar xcoord, uchar ycoord)
; CALLER linkage for function pointers

XLIB zx_pxy2aaddr

LIB zx_pxy2aaddr_callee
XREF ASMDISP_ZX_PXY2AADDR_CALLEE

.zx_pxy2aaddr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   ld h,e
   jp zx_pxy2aaddr_callee + ASMDISP_ZX_PXY2AADDR_CALLEE
