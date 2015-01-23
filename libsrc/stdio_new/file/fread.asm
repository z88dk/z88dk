; CALLER linkage for function pointers

PUBLIC fread
EXTERN fread_callee
EXTERN ASMDISP_FREAD_CALLEE

.fread

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   push hl
   push af
   
   jp fread_callee + ASMDISP_FREAD_CALLEE
