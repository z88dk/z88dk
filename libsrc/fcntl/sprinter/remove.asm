;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 30 September 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***

; This doesn't check for validity of filename at all.
;
; 27/4/99 Now takes a far char *name
;
; 15/4/2000 Takes a near again (can change but effort!)
;
;
;	$Id: remove.asm,v 1.1 2002-10-03 20:07:20 dom Exp $
;

                XLIB    remove

;int remove(char *name)

.remove
        pop     de
        pop     hl      ;dest filename
        push    hl
        push    de
	ld	c,$0E
	rst	$10
        ld      hl,0
        ret     nc
        dec     hl      ;=1
        ret

