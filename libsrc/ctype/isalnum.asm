;
;	Small C+ z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	This routine is a little bit unwieldy to say the least
;
;	$Id: isalnum.asm,v 1.5 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC isalnum
EXTERN asm_isalnum

; FASTCALL

.isalnum

   ld a,l
   call asm_isalnum
   ld hl,1
   ret nc
   dec l
   ret
