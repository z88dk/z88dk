
; SP1SetUpdateList
; 11.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1SetUpdateList
XREF SP1V_UPDATELISTH, SP1V_UPDATELISTT

; Sets the head and tail pointers for the current
; update list.  The struct sp1_updates in this list
; will be drawn during the next sp1_UpdateNow() call.
;
; enter : hl = struct sp1_update *head
;         de = struct sp1_update *tail
; uses  : none

.SP1SetUpdateList

   ld (SP1V_UPDATELISTH+5),hl
   ld (SP1V_UPDATELISTT),de
   ret
