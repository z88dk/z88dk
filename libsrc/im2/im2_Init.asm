; CALLER linkage for function pointers

XLIB im2_Init

LIB im2_Init_callee
XREF ASMDISP_IM2_INIT_CALLEE

.im2_Init

   pop hl
   pop bc
   pop af
   pop de
   push de
   push af
   push bc
   push hl
   
   jp im2_Init_callee + ASMDISP_IM2_INIT_CALLEE
