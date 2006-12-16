; uint in_Pause(uint ticks)
; 09.2005 aralbrec

XLIB in_Pause
LIB in_WaitForNoKey, in_WaitForKey

; Waits an approximate period of time measured in milliseconds and exits
; early if a key is pressed
;
; enter: HL = time to wait in ms, if 0 waits until key pressed
; exit : carry = exit early because of keypress with HL = time remaining
;        no carry = exit after time passed
; uses : AF,BC,HL

.in_Pause

   ld a,h
   or l
   jr nz, waitforkey

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
   xor a
   in a,($fe)
   and 31
   cp 31
   jr z, in_Pause

   scf
   ret

.waitforkey

   call in_WaitForNoKey
   jp in_WaitForKey
