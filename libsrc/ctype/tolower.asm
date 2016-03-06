;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: tolower.asm,v 1.7 2016-03-06 21:41:15 dom Exp $
;

        SECTION code_clib

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
