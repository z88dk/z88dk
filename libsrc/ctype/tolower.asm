;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: tolower.asm,v 1.6 2016-03-04 23:10:03 dom Exp $
;

PUBLIC tolower
PUBLIC _tolower
EXTERN asm_tolower

; FASTCALL

._tolower
.tolower

   ld a,l
   call asm_tolower
   ld l,a
   ld h,0
   ret
