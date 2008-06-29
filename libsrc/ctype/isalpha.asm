;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm
;
;	$Id: isalpha.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB isalpha
LIB asm_isalpha

; FASTCALL

.isalpha

   ld a,l
   call asm_isalpha
   ld hl,1
   ret nc
   dec l
   ret
