;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: isspace.asm,v 1.6 2016-03-04 23:10:02 dom Exp $
;

PUBLIC _isspace
PUBLIC isspace
EXTERN asm_isspace

; FASTCALL

._isspace
.isspace

   ld a,l
   call asm_isspace
   ld hl,0
   ret nz
   inc l
   ret
