; wrapper for function pointers

XLIB vsnprintf

LIB vsnprintf_callee
XREF ASMDISP_VSNPRINTF_CALLEE

.vsnprintf

   pop hl
   pop bc
   pop de
   exx
   pop de
   pop hl
   push hl
   push de
   exx
   push de
   push bc
   push hl
   
   jp vsnprintf_callee + ASMDISP_VSNPRINTF_CALLEE
