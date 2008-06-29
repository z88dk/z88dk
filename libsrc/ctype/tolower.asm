;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: tolower.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB tolower
LIB asm_tolower

; FASTCALL

.tolower

   ld a,l
   call asm_tolower
   ld l,a
   ld h,0
   ret
