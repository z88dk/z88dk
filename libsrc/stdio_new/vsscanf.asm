; wrapper for function pointers

XLIB vsscanf

LIB vsscanf_callee
XREF ASMDISP_VSSCANF_CALLEE

.vsscanf

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
   
   jp vsscanf_callee + ASMDISP_VSSCANF_CALLEE
