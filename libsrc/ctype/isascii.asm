;
;       Small C+ Library
;
;       ctype/isascii(char c)
;
;       djm 1/3/99
;
;	$Id: isascii.asm,v 1.8 2016-03-06 21:41:15 dom Exp $
;

        SECTION code_clib

PUBLIC _isascii
PUBLIC isascii

; FASTCALL

._isascii
.isascii

   ld a,l
   ld hl,1
   cp 128
   ret c
   dec l
   ret
