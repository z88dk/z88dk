; void in_Wait(uint ticks)
; 09.2005 aralbrec

XLIB in_Wait
LIB delay

; Waits a period of time measured in milliseconds.
;
; enter : HL = time to wait in ms
; used  : AF,BC,DE,HL

.in_Wait

; wait 1ms in loop controlled by HL
; at 3.5MHz, 1ms = 3500 T states

   ld e,l
   ld d,h

.loop

   ld hl,3500 - 36
   call delay                  ; wait exactly HL t-states
   
   dec de
   ld a,d
   or e
   jr nz, loop
   
   ret
