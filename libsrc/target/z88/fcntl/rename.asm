;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 30 September 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***

; This doesn't check for validity of filename at all.

;
;	$Id: rename.asm,v 1.5 2016-03-06 20:36:13 dom Exp $
;

                INCLUDE "fileio.def"
                INCLUDE "stdio.def"

                SECTION   code_clib

                PUBLIC    rename
                PUBLIC    _rename

;int rename(char *s1,char *s2)
;on stack:
;return address,s2,s1
;s1=orig filename, s2=dest filename

.rename
._rename
        pop     bc
        pop     de      ;dest filename
        pop     hl      ;orig filename
        push    hl
        push    de
        push    bc
        call_oz(gn_ren)	;ix preserved
        ld      hl,0
        ret     nc
        dec     hl      ;=1
        ret

