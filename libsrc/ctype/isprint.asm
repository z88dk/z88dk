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
;	$Id: isprint.asm,v 1.7 2016-03-06 21:41:15 dom Exp $
;

        SECTION code_clib

PUBLIC _isprint
PUBLIC isprint
EXTERN asm_isprint

; FASTCALL

._isprint
.isprint

   ld a,l
   call asm_isprint
   ld hl,1
   ret nc
   dec l
   ret
