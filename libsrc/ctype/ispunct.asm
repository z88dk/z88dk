;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	Hurrah, this is our first table for our isxxx routines!
;
;	$Id: ispunct.asm,v 1.5 2015-01-19 01:32:42 pauloscustodio Exp $
;

PUBLIC ispunct
EXTERN asm_ispunct

; FASTCALL

.ispunct

   ld a,l
   call asm_ispunct
   ld l,c
   ld h,b
   ret
