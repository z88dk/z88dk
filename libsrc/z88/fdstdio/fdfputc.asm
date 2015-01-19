;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***
;
; 11/3/99 djm - revised

                INCLUDE "fileio.def"
                INCLUDE "stdio.def"
                INCLUDE "libdefs.def"




                PUBLIC    fdfputc

;*fputc(n,fp)
;int n int fp
;on stack
;return address,fp,n
;n=byte to write, fp=filepointer
;


;fputc - put byte to file, should return written byte/EOF if error
;        If we come across a \n for stdout/err we call gn_nln

.fdfputc
        ld      hl,2
        add     hl,sp
        ld      e,(hl)  ;filehandle
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      c,(hl)  ;byte to put
        ld      a,d
        or      e
        jr      nz,fputc1
.fputc_abort
        ld      hl,EOF
        ret
.fputc1
        ld      hl,stdout
        and     a
        sbc     hl,de
        jr      z,fdputc_cons
        ld      hl,stdin
        and     a
        sbc     hl,de
        jr      z,fputc_abort
        ld      hl,stderr
        and     a
        sbc     hl,de
        jr      nz,fputc_file
;Output to stdin/out here
.fdputc_cons
        ld      a,c
        cp      13
        jr      nz,fputc_cons1
        call_oz(gn_nln)
        ld      hl,13
        ret
.fputc_cons1
        call_oz(os_out)
        ld      l,c
        ld      h,0
        ret

.fputc_file
        push    de
        pop     ix
        ld      a,c
        call_oz(os_pb)
        jr      c,fputc_abort
        ld      l,c
        ld      h,0
        ret


