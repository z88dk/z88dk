; wrapper for function pointers

XLIB vsprintf

LIB vsprintf_callee
XREF ASMDISP_VSPRINTF_CALLEE

.vsprintf

   pop hl
   pop bc
   pop de
   exx
   pop hl
   push hl
   exx
   push de
   push bc
   push hl
   
   jp vsprintf_callee + ASMDISP_VSPRINTF_CALLEE
