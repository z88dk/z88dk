;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: isspace.asm,v 1.5 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC isspace
EXTERN asm_isspace

; FASTCALL

.isspace

   ld a,l
   call asm_isspace
   ld hl,0
   ret nz
   inc l
   ret
