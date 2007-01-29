; void sp1_GetUpdateList(struct sp1_update **head, struct sp1_update **tail)
; CALLER linkage for function pointers

XLIB sp1_GetUpdateList
XREF SP1V_UPDATELISTH, SP1V_UPDATELISTT

.sp1_GetUpdateList

; Gets the head and tail pointers for the currently
; accumulated update list.
;
; uses  : bc, de, hl

   pop de
   pop hl
   ld bc,(SP1V_UPDATELISTT)
   ld (hl),c
   inc hl
   ld (hl),b
   pop hl
   ld bc,(SP1V_UPDATELISTH+6)
   ld (hl),c
   inc hl
   ld (hl),b
   push hl
   push hl
   ex de,hl
   jp (hl)

