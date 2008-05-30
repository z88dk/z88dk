; wrapper for function pointers

XLIB t_vsscanf

LIB t_vsscanf_callee
XREF ASMDISP_VSSCANF_CALLEE

.t_vsscanf

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
   
   jp t_vsscanf_callee + ASMDISP_VSSCANF_CALLEE
