; uint in_Pause(uint ticks)
; 09.2005 aralbrec

XLIB in_Pause

; Waits an approximate period of time measured in units of 1/50s but exits
; early if a key is pressed
;
; enter: HL = number of interrupts to wait
; exit : carry = exit early because of keypress with HL = ints remaining
;        no carry = exit after time passed
; uses : AF,HL

.in_Pause

   ld bc,2690

.loop                  ; about 70000 cycles here (1/50s)

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
