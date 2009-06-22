;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
;
; 11/3/99 djm ***UNTESTED***
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***
;
;
;	$Id: fdtell.asm,v 1.3 2009-06-22 21:44:16 dom Exp $
;

                INCLUDE "fileio.def"

                XLIB    fdtell

;long fdtell(int fd)

.fdtell
	pop	bc	;ret
	pop	ix	;fd
	push	ix
	push	bc
        ld      a,fa_ptr
        call_oz(os_frm)
        push    bc              ;get the var into our preferred regs
        pop     hl
        ret     nc
;Error, return with -1
        ld      hl,65535
        ld      d,h
        ld      e,l
        ret
