;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	Hurrah, this is our first table for our isxxx routines!
;
;	$Id: ispunct.asm,v 1.6 2016-03-04 23:10:02 dom Exp $
;

PUBLIC _ispunct
PUBLIC ispunct
EXTERN asm_ispunct

; FASTCALL

._ispunct
.ispunct

   ld a,l
   call asm_ispunct
   ld l,c
   ld h,b
   ret
