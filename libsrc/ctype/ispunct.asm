;
;	Small C z88 Character functions
;	Written by Dominic Morris <djm@jb.man.ac.uk>
;
;	1/3/99 djm
;
;	Hurrah, this is our first table for our isxxx routines!
;
;	$Id: ispunct.asm,v 1.3 2006-12-31 21:45:26 aralbrec Exp $
;

XLIB ispunct

; FASTCALL

.ispunct

   ld a,l
   ld hl,punctbl
   ld bc,punctend - punctbl
   cpir                      ; use it or lose it!
   ld h,b
   ld l,c
   ret

.punctbl

   defm "!$%^&*()_+={[]}#~'@;:/?.>,<\|"
   defb 34,163,163           ; quote and pound, must repeat last one

.punctend
