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
;	$Id: remove.asm,v 1.5 2016-03-06 20:36:13 dom Exp $
;

                INCLUDE "fileio.def"
                INCLUDE "stdio.def"

                SECTION   code_clib

                PUBLIC    remove
                PUBLIC    _remove

;int remove(char *name)

.remove
._remove
        pop     de
        pop     hl      ;dest filename
        push    hl
        push    de
	ld	b,0
        call_oz(gn_del)	;ix preserved
        ld      hl,0
        ret     nc
        dec     hl      ;=1
        ret

