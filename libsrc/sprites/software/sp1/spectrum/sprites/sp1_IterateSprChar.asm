; void sp1_IterateSprChar(struct sp1_ss *s, void *hook1)
; CALLER linkage for function pointers

PUBLIC sp1_IterateSprChar

EXTERN sp1_IterateSprChar_callee
EXTERN ASMDISP_SP1_ITERATESPRCHAR_CALLEE

.sp1_IterateSprChar

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   jp sp1_IterateSprChar_callee + ASMDISP_SP1_ITERATESPRCHAR_CALLEE
