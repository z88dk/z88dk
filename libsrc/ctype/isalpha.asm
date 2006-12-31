;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm
;
;	$Id: isalpha.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB isalpha

; FASTCALL

.isalpha

   ld a,l
   ld hl,0
   cp 'A'
   ret c
   cp 'z'+1
   ret nc
   and 223
   cp 'A'
   ret c
   cp 'Z'+1
   ret nc
   inc l
   ret
