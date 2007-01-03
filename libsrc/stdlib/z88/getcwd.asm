;
;       Z88 Small C+ Library Functions
;
;       Find current directory
;
;       Added to Small C archive 12/3/99
;
;       char *getcwd(char *buffer, int maxlen)
;
;       *** Z88 SPECIFIC ROUTINE - UNTESTED!!! ***
;
;
; -----
; $Id: getcwd.asm,v 1.5 2007-01-03 22:23:49 aralbrec Exp $

                INCLUDE "#syspar.def"
		INCLUDE	"#memory.def"

                XLIB    getcwd
                LIB    readbyte        ;standard.lib
                XDEF ASMDISP_GETCWD

.getcwd

        pop hl
        pop bc
        pop de
        push de
        push bc
        push hl

.asmentry

        ; bc = int maxlen
        ; de = char *buffer

        push    de
        push    bc
        ld      bc,NQ_dir       ;ask for current directory
        call_oz(os_nq)
        exx
        pop     bc              ;max len
        pop     de              ;buffer
	ld	hl,0
	ret	c		;error
        ld      l,d             ;keep buffer safe in hl
        ld      h,e
;Copying loop here..
.getcwd2
        ld      a,c
        or      b
        ret     z               ;we've filled our buffer
        exx
	call_oz(gn_rbe)
        inc     hl
        exx
        ld      (de),a
        and     a
        ret     z               ;end of dir string
        inc     de
        dec     bc
        jr      getcwd2
        
 DEFC ASMDISP_GETCWD = asmentry - getcwd
 