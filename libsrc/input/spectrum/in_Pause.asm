; uint in_Pause(uint ticks)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_Pause
PUBLIC _in_Pause
EXTERN in_WaitForNoKey, in_WaitForKey, t_delay

; Waits a period of time measured in milliseconds and exits
; early if a key is pressed
;
; enter: HL = time to wait in ms, if 0 waits forever until key pressed
; exit : carry = exit early because of keypress with HL = time remaining
;        no carry = exit after time passed
; uses : AF,BC,DE,HL

.in_Pause
._in_Pause

   ld a,h
   or l
   jr z, waitforkey
   
.loop

; wait 1ms then sample keyboard, in loop
; at 3.5MHz, 1ms = 3500 T states

   ex de,hl
   ld hl,3500 - 78
   call t_delay                  ; wait exactly HL t-states
   ex de,hl
   
   dec hl
   ld a,h
   or l
   ret z
   
   xor a
   in a,($fe)
   and 31
   cp 31
   jr z, loop

   scf
   ret

.waitforkey

   call in_WaitForNoKey
   jp in_WaitForKey
