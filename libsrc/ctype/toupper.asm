;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: toupper.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB toupper

; FASTCALL

.toupper

   ld a,l
   ld h,0
   cp 'a'
   ret c
   cp 'z'+1
   ret nc
   res 5,l
   ret
