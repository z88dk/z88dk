; wrapper for function pointers

XLIB vfscanf

LIB vfscanf_callee
XREF ASMDISP_VFSCANF_CALLEE

.vfscanf

   pop hl
   pop bc
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp vfscanf_callee + ASMDISP_VFSCANF_CALLEE
