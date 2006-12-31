;
;       Small C+ Library
;
;       ctype/toascii(char c)
;       returns c&127
;
;       djm 1/3/99
;
;	$Id: toascii.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB toascii

; FASTCALL

.toascii

   res 7,l
   ld h,0
   ret
