;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: isspace.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB isspace
LIB asm_isspace

; FASTCALL

.isspace

   ld a,l
   call asm_isspace
   ld hl,0
   ret nz
   inc l
   ret
