;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm - rewritten to remove jp - shorter
;
;	$Id: isupper.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB isupper
LIB asm_isupper

; FASTCALL

.isupper

   ld a,l
   call asm_isupper
   ld hl,0
   ret c
   inc l
   ret
