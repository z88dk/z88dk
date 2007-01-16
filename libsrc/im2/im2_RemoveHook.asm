; CALLER linkage for function pointers

XLIB im2_RemoveHook

LIB im2_RemoveHook_callee
XREF ASMDISP_REMOVEHOOK_CALLEE

.im2_RemoveHook

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp im2_RemoveHook_callee + ASMDISP_REMOVEHOOK_CALLEE
   