; void in_Wait(uint ticks)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_Wait
PUBLIC _in_Wait
EXTERN t_delay

; Waits a period of time measured in milliseconds.
;
; enter : HL = time to wait in ms
; used  : AF,BC,DE,HL

.in_Wait
._in_Wait

; wait 1ms in loop controlled by HL
; at 3.5MHz, 1ms = 3500 T states

   ld e,l
   ld d,h

.loop

   ld hl,3500 - 36
   call t_delay                  ; wait exactly HL t-states
   
   dec de
   ld a,d
   or e
   jr nz, loop
   
   ret
