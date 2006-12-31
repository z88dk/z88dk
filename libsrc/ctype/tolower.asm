;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: tolower.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB tolower

; FASTCALL

.tolower

   ld a,l
   ld h,0
   cp 'A'
   ret c
   cp 'Z'+1
   ret nc
   set 5,l
   ret
