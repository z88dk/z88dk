; void sp1_IterateSprChar(struct sp1_ss *s, void *hook1)
; CALLER linkage for function pointers

XLIB sp1_IterateSprChar

LIB sp1_IterateSprChar_callee
XREF ASMDISP_SP1_ITERATESPRCHAR_CALLEE

.sp1_IterateSprChar

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   jp sp1_IterateSprChar_callee + ASMDISP_SP1_ITERATESPRCHAR_CALLEE
