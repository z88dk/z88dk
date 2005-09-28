; void in_Wait(uint ticks)
; 09.2005 aralbrec

XLIB in_Wait

; Waits a fixed period of time measured in interrupts.
;
; enter : HL = number of interrupts to wait
; used  : AF,HL

.in_Wait
   halt
   dec hl
   ld a,h
   or l
   ret z
   jp in_Wait
