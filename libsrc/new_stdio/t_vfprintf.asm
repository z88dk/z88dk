; wrapper for function pointers

XLIB t_vfprintf

LIB t_vfprintf_callee
XREF ASMDISP_VFPRINTF_CALLEE

.t_vfprintf

   pop hl
   pop bc
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp t_vfprintf_callee + ASMDISP_VFPRINTF_CALLEE
