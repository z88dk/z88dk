;
;	Small C+ z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	$Id: isxdigit.asm,v 1.5 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC isxdigit
EXTERN asm_isxdigit

; FASTCALL

.isxdigit

   ld a,l
   call asm_isxdigit
   ld hl,0
   ret c
   inc l
   ret
