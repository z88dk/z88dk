; wrapper for function pointers

XLIB vscanf

LIB vfscanf_callee
XREF ASMDISP_VFSCANF_CALLEE, _stdin

.vscanf

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   ld ix,(_stdin)
   jp vfscanf_callee + ASMDISP_VFSCANF_CALLEE
