; CALLER linkage for function pointers
; 06.2008 aralbrec

PUBLIC fwrite

EXTERN fwrite_callee
EXTERN ASMDISP_FWRITE_CALLEE

.fwrite

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
   
   jp fwrite_callee + ASMDISP_FWRITE_CALLEE
