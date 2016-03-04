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
;	$Id: isprint.asm,v 1.6 2016-03-04 23:10:02 dom Exp $
;

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
