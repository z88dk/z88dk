;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***
;
; 11/3/99 Fixed for stdin
;
; 22/3/2000 Now calls getchar() for stdin stuff instead of doing
;	    os_in itself

                INCLUDE "fileio.def"
                INCLUDE "stdio.def"
                INCLUDE "libdefs.def"




                PUBLIC    fdfgetc
		EXTERN	fgetc_cons
                EXTERN     fhand_ck

;fgetc(fp)
;FILE *fp
;on stack
;return address,fp
;fp=filepointer
;

;fgetc - read byte from file - also handles stdin

.fdfgetc
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      a,d
        or      e
        jp      nz,fgetc1
.fgetc_abort
        ld      hl,EOF
        ret
.fgetc1
        call    fhand_ck
        jr      nz,fgetc_file
        ld      hl,stdin
        and     a
        sbc     hl,de
        jp      nz,fgetc_abort
	jp	fgetc_cons

.fgetc_file     
        push    de
        pop     ix
        call_oz(os_gb)
        jp      c,fgetc_abort
        ld      l,a
        ld      h,0
        ret
