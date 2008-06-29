;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	Hurrah, this is our first table for our isxxx routines!
;
;	$Id: ispunct.asm,v 1.4 2008-06-29 06:38:24 aralbrec Exp $
;

XLIB ispunct
LIB asm_ispunct

; FASTCALL

.ispunct

   ld a,l
   call asm_ispunct
   ld l,c
   ld h,b
   ret
