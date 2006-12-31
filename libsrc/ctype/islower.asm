;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm Rewritten to remove the jp and thus be shorter
;
;	$Id: islower.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB islower

; FASTCALL

.islower

   ld a,l
   ld hl,0
   cp 'a'
   ret c
   cp 'z'+1
   ret nc
   inc l
   ret
