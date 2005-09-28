; Set Mouse Position on AMX Mouse
; 09.2005 aralbrec

XLIB INMouseAMXSetPos
XREF _in_AMXcoordX, _in_AMXcoordY

; enter: C = x coord 0..255
;        B = y coord 0..191
; uses : A

.INMouseAMXSetPos
   ld a,c
   ld (_in_AMXcoordX + 1),a
   ld a,b
   ld (_in_AMXcoordY + 1),a
   ret
