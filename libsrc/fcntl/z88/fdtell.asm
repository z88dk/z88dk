;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
;
; 11/3/99 djm ***UNTESTED***
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***
;
;
;	$Id: fdtell.asm,v 1.6 2016-03-05 00:13:02 dom Exp $
;

                INCLUDE "fileio.def"

                PUBLIC    fdtell
                PUBLIC    _fdtell

;long fdtell(int fd)

.fdtell
._fdtell
	pop	bc	;ret
	pop	ix	;fd
	push	ix
	push	bc
        ld      a,FA_PTR
        call_oz(os_frm)
        push    bc              ;get the var into our preferred regs
        pop     hl
        ret     nc
;Error, return with -1
        ld      hl,65535
        ld      d,h
        ld      e,l
        ret
