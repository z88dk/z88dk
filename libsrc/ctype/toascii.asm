;
;       Small C+ Library
;
;       ctype/toascii(char c)
;       returns c&127
;
;       djm 1/3/99
;
;	$Id: toascii.asm,v 1.6 2016-03-06 21:41:15 dom Exp $
;

        SECTION code_clib

PUBLIC _toascii
PUBLIC toascii

; FASTCALL

._toascii
.toascii

   res 7,l
   ld h,0
   ret
