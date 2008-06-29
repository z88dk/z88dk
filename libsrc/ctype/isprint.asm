;
;	Small C+ Library
;
;	ctype/isprint(char c)
;
;	djm 23/12/99
;
;	Okay, printable for the z88 is:
;	7,10,13,32-126,163?
;
;	$Id: isprint.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB isprint
LIB asm_isprint

; FASTCALL

.isprint

   ld a,l
   call asm_isprint
   ld hl,1
   ret nc
   dec l
   ret
