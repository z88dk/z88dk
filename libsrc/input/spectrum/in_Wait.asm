; void in_Wait(uint ticks)
; 09.2005 aralbrec

XLIB in_Wait

; Waits an approximate period of time measured in 1/50s units.
;
; enter : HL = number of interrupts to wait
; used  : AF,HL

.in_Wait

   ld bc,2691

.loop                  ; about 70000 cycles here (1/50s)

   dec bc
   ld a,b
   or c
   jr nz,loop

   dec hl
   ld a,h
   or l
   ret z

   jp in_Wait
