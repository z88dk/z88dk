; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_chars(unsigned char *addr)

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_chars

_NIRVANA_chars:

	pop af
	pop hl

	push hl
	push af

        ld (56341),hl
        ret
