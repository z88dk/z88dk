;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;	22 August 1998
;
;	$Id: isspace.asm,v 1.3 2006-12-31 21:44:58 aralbrec Exp $
;

XLIB isspace

; FASTCALL

.isspace

   ld a,l
   ld hl,1
   cp 32                     ; space
   ret z
   cp 7                      ; tab
   ret z
   cp 10                     ; lf
   ret z
   cp 13                     ; cr
   ret z
   dec l
   ret
