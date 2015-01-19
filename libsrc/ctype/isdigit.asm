;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm rewritten to be shorter
;
;	$Id: isdigit.asm,v 1.5 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC isdigit
EXTERN asm_isdigit

; FASTCALL

.isdigit

   ld a,l
   call asm_isdigit
   ld hl,0
   ret c
   inc l
   ret
