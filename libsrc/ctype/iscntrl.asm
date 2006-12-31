;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	Stylish, this returned the wrong way! (djm 17/5/99)
;
;	$Id: iscntrl.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB iscntrl

; FASTCALL

.iscntrl

   ld a,l
   ld hl,0
   cp 32
   ret nc
   inc l
   ret
