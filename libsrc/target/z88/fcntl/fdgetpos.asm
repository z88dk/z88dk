;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
;
; 11/3/99 djm ***UNTESTED***
;
;
;	$Id: fdgetpos.asm,v 1.7 2016-03-06 20:36:12 dom Exp $
;

                INCLUDE "fileio.def"

		SECTION	  code_clib

                PUBLIC    fdgetpos
                PUBLIC    _fdgetpos

;int fgetpos(int fd, long *dump)
;
;Dumps in dump the file position, and returns 0 if all went well


.fdgetpos
._fdgetpos
	pop	bc
	pop	de	;dump
	pop	hl	;fd
	push	hl
	push	de
	push	bc
	push	ix	;save callers ix
	push	hl	;get file descriptor into right reg
	pop	ix

        push    de              ;store dumping place
        ld      a,FA_PTR
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
	pop	ix
        ld      hl,0            ;no errors
        ret
.fdgetpos_error
        pop	ix		;callers
	ld	hl,-1
	ret

