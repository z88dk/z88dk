; Read Kempston Mouse
; 08.2003 aralbrec

; based on Chris Cowley's Kempston Mouse
; driver for Spectrum Basic (2003)

SECTION code_clib
PUBLIC INMouseKemp
PUBLIC _INMouseKemp
EXTERN _in_KempcoordX, _in_KempcoordY
EXTERN _in_KemprawX, _in_KemprawY

; exit : C = button state 000000RL active high
;        B = X coordinate (0..255)
;        A = Y coordinate (0..191)
; uses : AF,BC,E

.INMouseKemp
._INMouseKemp

   ld a,(_in_KempcoordX)
   ld b,a                      ; b = current x coordinate
   
   ld a,(_in_KemprawX)
   ld e,a
   
   ld a,$fb
   in a,($df)
   
   ld (_in_KemprawX),a
   sub e                       ; a = delta x
   
   jp m, negdx

.posdx

   cp 80
   jr nc, overflowX            ; kill x movement if change is 1/3 of screen

   add a,b                     ; a = x + delta
   jp nc, Xok
   
   ld a,255                    ; moved past right side of screen
   jp Xok

.negdx

   neg                         ; make negative delta positive
   cp 80
   jr nc, overflowX            ; kill movement if change is 1/3 of screen
   
   ld c,a
   ld a,b
   sub c                       ; a = x - delta
   jp nc, Xok
   
   xor a                       ; moved past left side of screen

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
