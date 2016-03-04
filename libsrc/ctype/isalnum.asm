;
;	Small C+ z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	This routine is a little bit unwieldy to say the least
;
;	$Id: isalnum.asm,v 1.6 2016-03-04 23:10:02 dom Exp $
;

PUBLIC _isalnum
PUBLIC isalnum
EXTERN asm_isalnum

; FASTCALL

._isalnum
.isalnum

   ld a,l
   call asm_isalnum
   ld hl,1
   ret nc
   dec l
   ret
