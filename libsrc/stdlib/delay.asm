; void __FASTCALL__ delay(unsigned int tstates)

XLIB delay

; Z80 delay routine
; by JB, z88dk artistic license
;
; Delays an exact amount of time measured in Z80 cycles.
; This time includes the CALL to and RET from this
; subroutine.
;
; enter : hl = delay in T states (at least 160)
; uses  : af, de, hl

.delay

.b0

   ld a, l
   rra
   jr c, b1
   nop

; bit 0 set   : 20 T
; bit 0 reset : 19 T

.b1

   rra
   jr nc, b2
   jr nc, b2                   ; never taken

; bit 1 set   : 18 T
; bit 1 reset : 16 T

.b2

   rra
   jr nc, b3
   ret nc
   nop

; bit 2 set   : 20 T
; bit 2 reset : 16 T

.b3

   rra
   jr nc, b4
   jr nc, b4                   ; never taken
   dec de

; bit 3 set   : 24 T
; bit 3 reset : 16 T

.b4

   rra
   jr nc, preploop
   jr nc, preploop             ; never taken
   or a
   ld de,0

; bit 4 set   : 32 T
; bit 4 reset : 16 T
; carry flag reset

.preploop

   ex de,hl
   ld hl,191
   ld hl,191
   sbc hl,de
   ld de,32

; loop prep   : 49 T
; loop time = 11 + n*32 T (n = # times through loop)

.loop

   ret nc
   add hl,de
   ccf
   jr loop
