;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: toupper.asm,v 1.7 2016-03-06 21:41:15 dom Exp $
;

        SECTION code_clib

PUBLIC toupper
PUBLIC _toupper
EXTERN asm_toupper

; FASTCALL

._toupper
.toupper

   ld a,l
   call asm_toupper
   ld l,a
   ld h,0
   ret
