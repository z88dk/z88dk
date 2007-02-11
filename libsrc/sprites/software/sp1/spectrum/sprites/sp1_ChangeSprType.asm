; void sp1_ChangeSprType(struct sp1_cs *c, uchar type)
; CALLER linkage for function pointers

XLIB sp1_ChangeSprType

LIB sp1_ChangeSprType_callee
XREF ASMDISP_SP1_CHANGESPRTYPE_CALLEE

.sp1_ChangeSprType

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   jp sp1_ChangeSprType_callee + ASMDISP_SP1_CHANGESPRTYPE_CALLEE
