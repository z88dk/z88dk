;
; Small C z88 stdlib functions
;
; Return absolute value of long
;
; -----
; $Id: labs.asm,v 1.3 2006-12-31 22:13:19 aralbrec Exp $

XLIB labs
LIB l_long_neg

;labs(long num)  

.labs

   ld hl,5
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   
   bit 7,d
   ret z
   
   jp l_long_neg
