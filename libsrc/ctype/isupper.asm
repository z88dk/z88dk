;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm - rewritten to remove jp - shorter
;
;	$Id: isupper.asm,v 1.7 2016-03-06 21:41:15 dom Exp $
;

        SECTION code_clib

PUBLIC _isupper
PUBLIC isupper
EXTERN asm_isupper

; FASTCALL

._isupper
.isupper

   ld a,l
   call asm_isupper
   ld hl,0
   ret c
   inc l
   ret
