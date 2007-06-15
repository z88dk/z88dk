; uint screenstr(uchar row, uchar col)
; CALLER linkage for function pointers

XLIB screenstr

LIB screenstr_callee
XREF ASMDISP_SCREENSTR_CALLEE

.screenstr

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   ld h,e
   jp screenstr_callee + ASMDISP_SCREENSTR_CALLEE

