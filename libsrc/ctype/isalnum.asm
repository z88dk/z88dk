;
;	Small C+ z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	This routine is a little bit unwieldy to say the least
;
;	$Id: isalnum.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB isalnum

; FASTCALL

.isalnum

   ld a,l
   ld hl,0

   ; check digits [09]

   cp '0'
   ret c
   inc l
   cp '9'+1
   ret c

   ; now check chars [azAZ]
   
   dec l
   cp 'A'
   ret c
   cp 'z'+1
   ret nc
   
   and 223
   cp 'A'
   ret c
   cp 'Z'+1
   ret nc
   
   inc l
   ret
