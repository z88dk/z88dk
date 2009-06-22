;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
;
; 11/3/99 djm ***UNTESTED***
;
;
;	$Id: fdgetpos.asm,v 1.3 2009-06-22 21:44:16 dom Exp $
;

                INCLUDE "fileio.def"

                XLIB    fdgetpos

;int fgetpos(int fd, long *dump)
;
;Dumps in dump the file position, and returns 0 if all went well


.fdgetpos
	pop	bc
	pop	de	;dump
	pop	ix	;fd
	push	ix
	push	de
	push	bc
        push    de              ;store dumping place
        ld      a,fa_ptr
        call_oz(os_frm)
        pop     hl              ;dumping place
	jr	c,fdgetpos_error
        ld      (hl),c          ;store the file posn now
        inc     hl
        ld      (hl),b
        inc     hl
        ld      (hl),e
        inc     hl
        ld      (hl),d
        ld      hl,0            ;no errors
        ret
.fdgetpos_error
	ld	hl,-1
	ret

