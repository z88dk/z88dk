;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: toupper.asm,v 1.5 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC toupper
EXTERN asm_toupper

; FASTCALL

.toupper

   ld a,l
   call asm_toupper
   ld l,a
   ld h,0
   ret
