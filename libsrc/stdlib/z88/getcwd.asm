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
; $Id: getcwd.asm,v 1.4 2002-04-17 21:30:26 dom Exp $

                INCLUDE "#syspar.def"
		INCLUDE	"#memory.def"

                XLIB    getcwd
                LIB    readbyte        ;standard.lib

.getcwd
        ld      hl,2
        add     hl,sp
        ld      c,(hl)          ;max length
        inc     hl
        ld      b,(hl)
        inc     hl
        ld      e,(hl)          ;buffer to dump it into
        inc     hl
        ld      d,(hl)
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
        
        
