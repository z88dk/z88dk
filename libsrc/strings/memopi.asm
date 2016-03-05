; CALLER linkage for function pointers

PUBLIC memopi
PUBLIC _memopi
EXTERN memopi_callee
EXTERN ASMDISP_MEMOPI_CALLEE

.memopi
._memopi

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push bc
   push af
   
   jp memopi_callee + ASMDISP_MEMOPI_CALLEE
