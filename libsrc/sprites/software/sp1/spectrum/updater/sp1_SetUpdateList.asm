; void sp1_SetUpdateList(struct sp1_update *head, struct sp1_update *tail)
; CALLER linkage for function pointers

XLIB sp1_SetUpdateList
XREF SP1V_UPDATELISTH, SP1V_UPDATELISTT

.sp1_SetUpdateList

   pop de
   pop hl
   ld (SP1V_UPDATELISTT),hl
   pop hl
   ld (SP1V_UPDATELISTH+6),hl
   push hl
   push hl
   ex de,hl
   jp (hl)
