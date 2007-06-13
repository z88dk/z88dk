; uint zx_saddr2px(void *pixeladdr, uchar mask)
; CALLER linkage for function pointers

XLIB zx_saddr2px

LIB zx_saddr2px_callee
XREF ASMDISP_ZX_SADDR2PX_CALLEE

.zx_saddr2px

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   ld a,e
   jp zx_saddr2px_callee + ASMDISP_ZX_SADDR2PX_CALLEE

