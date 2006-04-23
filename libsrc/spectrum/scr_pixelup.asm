; 04.2006 aralbrec

; void __FASTCALL__ *scr_pixelup(void *scrnaddr)

XLIB scr_pixelup

.scr_pixelup

; Adjusts screen address HL to move one pixel up in the display.
; (0,0) is located at the top left corner of the screen.
;
; enter: HL = valid screen address
; exit : Carry = moved off screen
;        HL = moves one pixel up
; used : AF, HL

   ld a,h
   dec h
   and $07
   ret nz
   ld a,$08
   add a,h
   ld h,a
   ld a,l
   sub $20
   ld l,a
   ret nc
   ld a,h
   sub $08
   ld h,a
   cp $40
   ret
