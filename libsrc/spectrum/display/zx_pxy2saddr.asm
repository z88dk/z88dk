; uchar *zx_pxy2saddr(uchar xcoord, uchar ycoord, uchar *mask)
; CALLER linkage for function pointers

XLIB zx_pxy2saddr

LIB zx_pxy2saddr_callee
XREF ASMDISP_ZX_PXY2SADDR_CALLEE

.zx_pxy2saddr

   pop af
   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   push af
   
   ld h,c
   jp zx_pxy2saddr_callee + ASMDISP_ZX_PXY2SADDR_CALLEE
