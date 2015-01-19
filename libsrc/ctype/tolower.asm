;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: tolower.asm,v 1.5 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC tolower
EXTERN asm_tolower

; FASTCALL

.tolower

   ld a,l
   call asm_tolower
   ld l,a
   ld h,0
   ret
