;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***
;
; Few little bugs sorted out 13/10/98

                INCLUDE "fileio.def"
                INCLUDE "stdio.def"
                INCLUDE "libdefs.def"

                PUBLIC    fdfputs
                EXTERN     putconsole

;*fputs(s1,fp)
;char s1 int fp
;on stack
;return address,fp,s1
;s1 = buffer, fp=filepointer
;

;fputs - read bytes from file..
;these routines should check for stdin/out/err

.fdfputs
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      a,d
        or      e
        jp      nz,fputs1
.fputs_abort
        ld      hl,0            ;there is no return value really..
        ret
.fputs1
        inc     hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)          ;bc=out buffer
        ld      hl,stdout
        and     a
        sbc     hl,de
        jr      z,fputs_cons
        ld      hl,stderr
        and     a
        sbc     hl,de
        jr      nz,fputs_file
.fputs_cons
        ld      l,c
        ld      h,b
        xor     a
        jp      putconsole

.fputs_file
        push    de
        pop     ix
.fputs_file1
        ld      a,(bc)
        and     a
        ret     z
        call_oz(os_pb)
        inc     bc
        jp      fputs_file1
