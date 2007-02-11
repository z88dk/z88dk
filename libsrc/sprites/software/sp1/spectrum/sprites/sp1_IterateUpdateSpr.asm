; void sp1_IterateUpdateSpr(struct sp1_ss *s, void *hook2)
; CALLER linkage for function pointers

XLIB sp1_IterateUpdateSpr

LIB sp1_IterateUpdateSpr_callee
XREF ASMDISP_SP1_ITERATEUPDATESPR_CALLEE

.sp1_IterateUpdateSpr

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   jp sp1_IterateUpdateSpr_callee + ASMDISP_SP1_ITERATEUPDATESPR_CALLEE
