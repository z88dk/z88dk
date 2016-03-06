;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm rewritten to be shorter
;
;	$Id: isdigit.asm,v 1.7 2016-03-06 21:41:15 dom Exp $
;

        SECTION code_clib

PUBLIC _isdigit
PUBLIC isdigit
EXTERN asm_isdigit

; FASTCALL

._isdigit
.isdigit

   ld a,l
   call asm_isdigit
   ld hl,0
   ret c
   inc l
   ret
