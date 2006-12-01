
; SP1GetUpdateList
; 11.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1GetUpdateList
XREF SP1V_UPDATELISTH, SP1V_UPDATELISTT

; Gets the head and tail pointers for the currently
; accumulated update list.
;
; exit  : hl = struct sp1_update *head
;         de = struct sp1_update *tail
; uses  : de, hl

.SP1GetUpdateList

   ld hl,(SP1V_UPDATELISTH+5)
   ld de,(SP1V_UPDATELISTT)
   ret
