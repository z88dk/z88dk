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
;	$Id: remove.asm,v 1.1 2001-05-01 13:55:21 dom Exp $
;

                INCLUDE "#fileio.def"
                INCLUDE "#stdio.def"

                XLIB    remove

;int remove(char *name)

.remove
        pop     de
        pop     hl      ;dest filename
        push    hl
        push    de
	ld	b,0
        call_oz(gn_del)
        ld      hl,0
        ret     nc
        dec     hl      ;=1
        ret

