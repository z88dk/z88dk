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
;	$Id: isprint.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB isprint

; FASTCALL

.isprint

   ld a,l
   ld hl,1
   cp 7                      ; entry point for isgraph()
   ret z
   cp 10
   ret z
   cp 13
   ret z
   cp 163                    ; UK pound
   ret z
   dec l
   cp 32
   ret c
   cp 127
   ret nc
   inc l
   ret
