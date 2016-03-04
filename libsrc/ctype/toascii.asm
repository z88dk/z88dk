;
;       Small C+ Library
;
;       ctype/toascii(char c)
;       returns c&127
;
;       djm 1/3/99
;
;	$Id: toascii.asm,v 1.5 2016-03-04 23:10:03 dom Exp $
;

PUBLIC _toascii
PUBLIC toascii

; FASTCALL

._toascii
.toascii

   res 7,l
   ld h,0
   ret
