; Read AMX Mouse
; 08.2003 aralbrec

SECTION code_clib
PUBLIC INMouseAMX
PUBLIC _INMouseAMX
EXTERN _in_AMXcoordX, _in_AMXcoordY

; exit : C = button state 00000MRL active high
;        B = X coordinate (0..255)
;        A = Y coordinate (0..191)
; uses : AF,BC,HL

.INMouseAMX
._INMouseAMX
   ld c,$1f
   in a,($df)      ; mouse button state will randomly
   or c            ; fluctuate except when the mouse
   ld c,a          ; buttons are really pressed!
   in a,($df)      ; let's hope reading the buttons
   or c            ; five times is enough
   ld c,a
   in a,($df)
   or c
   ld c,a
   in a,($df)
   or c
   ld c,a
   in a,($df)
   or c

   rlca
   rlca
   rlca
   and $07
   add a,buttbl % 256
   ld l,a
   ld h,buttbl / 256
   jr nc, noinc
   inc h
.noinc
   ld c,(hl)       ; c = button state

   ld a,(_in_AMXcoordX + 1)
   ld b,a
   ld a,(_in_AMXcoordY + 1)
   cp 192
   ret c
   ld a,191
   ld (_in_AMXcoordY + 1),a
   ret

.buttbl
   defb $07, $03, $05, $01, $06, $02, $04, $00
