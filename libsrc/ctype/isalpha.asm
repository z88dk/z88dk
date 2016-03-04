;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm
;
;	$Id: isalpha.asm,v 1.6 2016-03-04 23:10:02 dom Exp $
;

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
