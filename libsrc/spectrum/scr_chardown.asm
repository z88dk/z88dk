; 04.2006 aralbrec

; void __FASTCALL__ *scr_chardown(void *scrnaddr)

XLIB scr_chardown

.scr_chardown

; Adjusts screen address to move eight pixels down on the display.
;
; enter: HL = valid screen address
; exit : Carry = moved off screen
;        HL = moves one character down
; used : AF, HL

   ld a,l
   add a,$20
   ld l,a
   ret nc
   ld a,h
   add a,$08
   ld h,a
   cp $58
   ccf
   ret

