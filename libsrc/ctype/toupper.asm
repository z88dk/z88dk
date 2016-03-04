;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: toupper.asm,v 1.6 2016-03-04 23:10:03 dom Exp $
;

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
