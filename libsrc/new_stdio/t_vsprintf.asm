; wrapper for function pointers

XLIB t_vsprintf

LIB t_vsprintf_callee
XREF ASMDISP_VSPRINTF_CALLEE

.t_vsprintf

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
   
   jp t_vsprintf_callee + ASMDISP_VSPRINTF_CALLEE
