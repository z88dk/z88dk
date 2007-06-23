; uint zx_screenstr(uchar row, uchar col)
; CALLER linkage for function pointers

XLIB zx_screenstr

LIB zx_screenstr_callee
XREF ASMDISP_ZX_SCREENSTR_CALLEE

.zx_screenstr

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   ld h,e
   jp zx_screenstr_callee + ASMDISP_ZX_SCREENSTR_CALLEE

