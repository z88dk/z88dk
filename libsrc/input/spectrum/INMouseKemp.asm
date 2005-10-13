; Read Kempston Mouse
; 08.2003 aralbrec

; based on Chris Cowley's Kempston Mouse
; driver for Spectrum Basic (2003)

XLIB INMouseKemp
XREF _in_KempcoordX, _in_KempcoordY
XREF _in_KemprawX, _in_KemprawY

; exit : C = button state 000000RL active high
;        B = X coordinate (0..255)
;        A = Y coordinate (0..191)
; uses : AF,BC,E

.INMouseKemp
   ld a,(_in_KempcoordX)
   ld b,a
   ld a,(_in_KemprawX)
   ld e,a
   ld a,$fb
   in a,($df)
   ld (_in_KemprawX),a
   sub e                       ; A = delta X
   jp pe, overflowX            ; kill the X movement if overflow
   jp m, negdx

.posdx
   add a,b
   jr nc, Xok
   ld a,255
   jp Xok

.negdx
   add a,b
   jp po, Xok
   xor a

.Xok
   ld (_in_KempcoordX),a
   ld b,a

.overflowX
.dobuts
   ld a,$fa
   in a,($df)
   and $03
   ld c,a
   rla
   srl c
   or $fc
   or c
   cpl
   ld c,a                      ; c = buttons 000000RL active high

.doY
   ld a,(_in_KemprawY)
   ld e,a
   ld a,$ff
   in a,($df)
   ld (_in_KemprawY),a
   sub e
   ld e,a                      ; E = delta Y
   ld a,(_in_KempcoordY)
   sub e
   cp 192
   jr c, Yok
   add a,e                     ; Y moved off screen, were we close to top or bottom?
   cp 96
   ld a,191
   jr nc, Yok
   xor a

.Yok
   ld (_in_KempcoordY),a
   ret
