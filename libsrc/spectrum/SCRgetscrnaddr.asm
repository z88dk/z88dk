; 04.2006 aralbrec

XLIB SCRgetscrnaddr

.SCRgetscrnaddr

; Computes the screen address given a valid pixel coordinate.
; (0,0) is located at the top left corner of the screen.
;
; enter: a = h = y coord
;        l = x coord
; exit : de = screen address, b = pixel mask
; uses : af, b, de, hl

   and $07
   or $40
   ld d,a
   ld a,h
   rra
   rra
   rra
   and $18
   or d
   ld d,a

   ld a,l
   and $07
   ld b,a
   ld a,$80
   jr z, norotate

.rotloop
   rra
   djnz rotloop

.norotate
   ld b,a
   srl l
   srl l
   srl l
   ld a,h
   rla
   rla
   and $e0
   or l
   ld e,a
   ret
