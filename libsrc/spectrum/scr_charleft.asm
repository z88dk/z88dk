; 04.2006 aralbrec

; void __FASTCALL__ *scr_charleft(void *scrnaddr)

XLIB scr_charleft

.scr_charleft

; Adjusts screen address HL to move one character to the left
; on the display.  Start of line wraps to the previous row.
;
; enter: HL = valid screen address
; exit : Carry = moved off screen
;        HL = moves one character left, with line wrap
; used : AF, HL

   ld a,l
   dec l
   or a
   ret nz
   ld a,h
   sub $08
   ld h,a
   cp $40
   ret
