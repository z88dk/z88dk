;
;	Small C+ z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	$Id: isxdigit.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB isxdigit
LIB asm_isxdigit

; FASTCALL

.isxdigit

   ld a,l
   call asm_isxdigit
   ld hl,0
   ret c
   inc l
   ret
