;
;       Small C+ Library
;
;       ctype/isascii(char c)
;
;       djm 1/3/99
;
;	$Id: isascii.asm,v 1.7 2016-03-04 23:10:02 dom Exp $
;

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
