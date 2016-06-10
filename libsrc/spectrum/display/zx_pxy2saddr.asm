; uchar *zx_pxy2saddr(uchar xcoord, uchar ycoord, uchar *mask)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_pxy2saddr
PUBLIC _zx_pxy2saddr

EXTERN zx_pxy2saddr_callee
EXTERN ASMDISP_ZX_PXY2SADDR_CALLEE

.zx_pxy2saddr
._zx_pxy2saddr

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
