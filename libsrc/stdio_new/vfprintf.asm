; wrapper for function pointers

XLIB vfprintf

LIB vfprintf_callee
XREF ASMDISP_VFPRINTF_CALLEE

.vfprintf

   pop hl
   pop bc
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp vfprintf_callee + ASMDISP_VFPRINTF_CALLEE
