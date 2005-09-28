; Set Mouse Position on Kempston Mouse
; 09.2005

XLIB INMouseKempSetPos
LIB INMouseKemp
XREF _in_KempcoordX, _in_KempcoordY

; enter: C = x coord 0..255
;        B = y coord 0..191
; uses : A

.INMouseKempSetPos
   push bc
   call INMouseKemp          ; to zero out current delta in kemp
   pop bc
   ld a,c
   ld (_in_KempcoordX),a
   ld a,b
   ld (_in_KempcoordY),a
   ret
