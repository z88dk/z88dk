;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***
;
; 11/3/99 Visited to fix, jp nz,feof_abort was jp z,feof_abort
; if we enter in with a std* stream then we exit with error
;
                INCLUDE "fileio.def"

                PUBLIC    fdfeof
                EXTERN     fhand_ck

;*feof(fp)
;int fp
;on stack
;return address,fp
;fp file handle to query if at end of file


.fdfeof
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        call    fhand_ck
        jr      nz,feof1
.feof_abort
        ld      hl,-1           ;error!
        ret
.feof1
        push    de
        pop     ix
        ld      a,FA_EOF
        call_oz(os_frm)
        jp      nz,feof_abort
        jp      c,feof_abort
        ld      hl,0
        ret
