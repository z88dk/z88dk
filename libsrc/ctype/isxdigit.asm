;
;	Small C+ z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	$Id: isxdigit.asm,v 1.6 2016-03-04 23:10:03 dom Exp $
;

PUBLIC _isxdigit
PUBLIC isxdigit
EXTERN asm_isxdigit

; FASTCALL

._isxdigit
.isxdigit

   ld a,l
   call asm_isxdigit
   ld hl,0
   ret c
   inc l
   ret
