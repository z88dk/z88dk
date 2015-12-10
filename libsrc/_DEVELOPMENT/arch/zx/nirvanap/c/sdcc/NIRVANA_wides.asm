; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_wides(unsigned char *addr)

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_wides

_NIRVANA_wides:

	pop af
	pop hl

	push hl
	push af

        ld (56111),hl
        ret
