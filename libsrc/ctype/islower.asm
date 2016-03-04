;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	17/2/99 djm Rewritten to remove the jp and thus be shorter
;
;	$Id: islower.asm,v 1.6 2016-03-04 23:10:02 dom Exp $
;

PUBLIC _islower
PUBLIC islower
EXTERN asm_islower

; FASTCALL

._islower
.islower

   ld a,l
   call asm_islower
   ld hl,0
   ret c
   inc l
   ret
