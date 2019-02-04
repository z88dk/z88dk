; CALLER linkage for function pointers

SECTION code_clib
PUBLIC im2_RemoveHook
PUBLIC _im2_RemoveHook

EXTERN im2_RemoveHook_callee
EXTERN ASMDISP_REMOVEHOOK_CALLEE

.im2_RemoveHook
._im2_RemoveHook

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp im2_RemoveHook_callee + ASMDISP_REMOVEHOOK_CALLEE
   
