;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm rewritten to be shorter
;
;	$Id: isdigit.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB isdigit

; FASTCALL

.isdigit

   ld a,l
   ld hl,0
   cp '0'
   ret c
   cp '9'+1
   ret nc
   inc l
   ret
