;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm Rewritten to remove the jp and thus be shorter
;
;	$Id: islower.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB islower
LIB asm_islower

; FASTCALL

.islower

   ld a,l
   call asm_islower
   ld hl,0
   ret c
   inc l
   ret
