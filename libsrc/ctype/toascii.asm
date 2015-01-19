;
;       Small C+ Library
;
;       ctype/toascii(char c)
;       returns c&127
;
;       djm 1/3/99
;
;	$Id: toascii.asm,v 1.4 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC toascii

; FASTCALL

.toascii

   res 7,l
   ld h,0
   ret
