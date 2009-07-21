;
;       Small C+ Library
;
;       ctype/isascii(char c)
;
;       djm 1/3/99
;
;	$Id: isascii.asm,v 1.5 2009-07-21 21:14:57 dom Exp $
;

XLIB isascii

; FASTCALL

.isascii

   ld a,l
   ld hl,1
   cp 128
   ret c
   dec l
   ret
