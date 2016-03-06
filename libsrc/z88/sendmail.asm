;
;       Small C+ Runtime Library
;
;       Z88 Application functions
;
;       *** Z88 SPECIFIC FUNCTION - probably no equiv for your machine! ***
;
;       11/4/99
;
;       Send Mail
;
;       int sendmail(char *type, char *info, int length)
;
;       Returns 0 on failure, number of bytes present on success


        SECTION code_clib

                PUBLIC    sendmail
                PUBLIC    _sendmail

                INCLUDE "saverst.def"

.sendmail
._sendmail
        ld      hl,2
        add     hl,sp   ;point to length parameter
        ld      c,(hl)
        inc     hl
        inc     hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ; lower 16 of info
	ld	b,0	; keep it near
        inc     hl
        ld      a,(hl)  
        inc     hl
        ld      h,(hl)  
        ld      l,a     ; hl holds name of info type
        ex      de,hl   ; get parameters the right way round
        ld      a,SR_WPD
        call_oz(os_sr)
        ld      hl,0
        ret     c
        ld      l,c
        ret
