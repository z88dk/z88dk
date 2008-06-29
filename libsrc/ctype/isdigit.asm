;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm rewritten to be shorter
;
;	$Id: isdigit.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB isdigit
LIB asm_isdigit

; FASTCALL

.isdigit

   ld a,l
   call asm_isdigit
   ld hl,0
   ret c
   inc l
   ret
