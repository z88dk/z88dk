;
;       Small C+ Library
;
;       ctype/isascii(char c)
;
;       djm 1/3/99
;
;	$Id: isascii.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB isascii

; FASTCALL

.isascii

   ld a,l
   ld hl,1
   cp 128
   ret c
   inc l
   ret
