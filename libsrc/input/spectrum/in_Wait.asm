; void in_Wait(uint ticks)
; 09.2005 aralbrec

XLIB in_Wait

; Waits an approximate period of time measured in milliseconds.
;
; enter : HL = time to wait in ms
; used  : AF,BC,HL

.in_Wait

   ld bc,134

.loop                  ; about 3500 cycles here (1ms)

   dec bc
   ld a,b
   or c
   jr nz,loop

   dec hl
   ld a,h
   or l
   ret z

   jp in_Wait
