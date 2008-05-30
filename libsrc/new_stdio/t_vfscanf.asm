; wrapper for function pointers

XLIB t_vfscanf

LIB t_vfscanf_callee
XREF ASMDISP_VFSCANF_CALLEE

.t_vfscanf

   pop hl
   pop bc
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp t_vfscanf_callee + ASMDISP_VFSCANF_CALLEE
