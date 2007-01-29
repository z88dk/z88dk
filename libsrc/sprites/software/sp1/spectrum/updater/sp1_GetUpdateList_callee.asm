; void __CALLEE__ sp1_GetUpdateList_callee(struct sp1_update **head, struct sp1_update **tail)
; 11.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB sp1_GetUpdateList_callee
XREF SP1V_UPDATELISTH, SP1V_UPDATELISTT

.sp1_GetUpdateList_callee

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
   ex de,hl
   jp (hl)
