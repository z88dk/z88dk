; 04.2006 aralbrec

; void __FASTCALL__ *scr_charright(void *scrnaddr)

XLIB scr_charright

.scr_charright

; Adjusts screen address HL to move one character to the right
; on the display.  End of line wraps to the next row.
;
; enter: HL = valid screen address
; exit : Carry = moved off screen
;        HL = moves one character right, with line wrap
; used : AF, HL

   inc l
   ret nz
   ld a,8
   add a,h
   ld h,a
   cp $58
   ccf
   ret

