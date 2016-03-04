;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm rewritten to be shorter
;
;	$Id: isdigit.asm,v 1.6 2016-03-04 23:10:02 dom Exp $
;

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
