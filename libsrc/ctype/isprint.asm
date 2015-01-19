;
;	Small C+ Library
;
;	ctype/isprint(char c)
;
;	djm 23/12/99
;
;	Okay, printable for the z88 is:
;	7,10,13,32-126,163?
;
;	$Id: isprint.asm,v 1.5 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC isprint
EXTERN asm_isprint

; FASTCALL

.isprint

   ld a,l
   call asm_isprint
   ld hl,1
   ret nc
   dec l
   ret
