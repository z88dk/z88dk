; 04.2006 aralbrec

; void __FASTCALL__ *scr_charup(void *scrnaddr)

XLIB scr_charup

.scr_charup

; Adjusts screen address HL to move eight pixels up on the display.
;
; enter: HL = valid screen address
; exit : Carry = moved off screen
;        HL = moves one character up
; used : AF, HL

   ld a,l
   sub $20
   ld l,a
   ret nc
   ld a,h
   sub $08
   ld h,a
   cp $40
   ret
