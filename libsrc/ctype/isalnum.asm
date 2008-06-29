;
;	Small C+ z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	This routine is a little bit unwieldy to say the least
;
;	$Id: isalnum.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB isalnum
LIB asm_isalnum

; FASTCALL

.isalnum

   ld a,l
   call asm_isalnum
   ld hl,1
   ret nc
   dec l
   ret
