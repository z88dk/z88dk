;
;       Small C+ Runtime Library
;
;       Z88 Application functions
;
;       *** Z88 SPECIFIC FUNCTION - probably no equiv for your machine! ***
;
;       11/4/99
;
;       Read Mail
;
;       int readmail(char *type, char *info, int length)
;
;       Returns 0 on failure, 1 on success


        SECTION code_clib

                PUBLIC    readmail
                PUBLIC    _readmail

                INCLUDE "saverst.def"

.readmail
._readmail
        ld      hl,2
        add     hl,sp   ;point to length parameter
        ld      c,(hl)
        inc     hl
        inc     hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ; lower 16 of info
	ld	b,0	; we keep it local (near)
        inc     hl
        ld      a,(hl)  
        inc     hl
        ld      h,(hl)  
        ld      l,a     ; hl holds name of info type
        ex      de,hl   ; get parameters the right way round
        ld      a,SR_RPD
        call_oz(os_sr)
        ld      hl,0
        ret     c
        inc     hl
        ret
