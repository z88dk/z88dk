; void __CALLEE__ sp1_SetUpdateList_callee(struct sp1_update *head, struct sp1_update *tail)
; 11.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB sp1_SetUpdateList_callee
XREF SP1V_UPDATELISTH, SP1V_UPDATELISTT

.sp1_SetUpdateList_callee

   pop de
   pop hl
   ld (SP1V_UPDATELISTT),hl
   pop hl
   ld (SP1V_UPDATELISTH+6),hl
   ex de,hl
   jp (hl)
