;
;       Small C+ Library
;
;       ctype/isascii(char c)
;
;       djm 1/3/99
;
;	$Id: isascii.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB isascii

; FASTCALL

.isascii

   ld a,l
   ld hl,0
   cp 128
   ret nc
   inc l
   ret
