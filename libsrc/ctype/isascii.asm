;
;       Small C+ Library
;
;       ctype/isascii(char c)
;
;       djm 1/3/99
;
;	$Id: isascii.asm,v 1.6 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC isascii

; FASTCALL

.isascii

   ld a,l
   ld hl,1
   cp 128
   ret c
   dec l
   ret
