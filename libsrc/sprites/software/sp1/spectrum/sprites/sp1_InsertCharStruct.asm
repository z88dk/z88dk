; void sp1_InsertCharStruct(struct sp1_update *u, struct sp1_cs *cs)
; CALLER linkage for function pointers

XLIB sp1_InsertCharStruct

LIB sp1_InsertCharStruct_callee
XREF ASMDISP_SP1_INSERTCHARSTRUCT_CALLEE

.sp1_InsertCharStruct

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   jp sp1_InsertCharStruct_callee + ASMDISP_SP1_INSERTCHARSTRUCT_CALLEE
