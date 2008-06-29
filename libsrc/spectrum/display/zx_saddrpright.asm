; uchar *zx_saddrpright(void *pixeladdr, uchar *mask)
; CALLER linkage for function pointers

XLIB zx_saddrpright

LIB zx_saddrpright_callee
XREF ASMDISP_ZX_SADDRPRIGHT_CALLEE

.zx_saddrpright

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp zx_saddrpright_callee + ASMDISP_ZX_SADDRPRIGHT_CALLEE
