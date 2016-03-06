;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm
;
;	$Id: isalpha.asm,v 1.7 2016-03-06 21:41:15 dom Exp $
;

        SECTION code_clib

PUBLIC _isalpha
PUBLIC isalpha
EXTERN asm_isalpha

; FASTCALL

._isalpha
.isalpha

   ld a,l
   call asm_isalpha
   ld hl,1
   ret nc
   dec l
   ret
