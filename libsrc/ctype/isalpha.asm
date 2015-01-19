;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm
;
;	$Id: isalpha.asm,v 1.5 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC isalpha
EXTERN asm_isalpha

; FASTCALL

.isalpha

   ld a,l
   call asm_isalpha
   ld hl,1
   ret nc
   dec l
   ret
