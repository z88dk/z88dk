; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_wides(unsigned char *addr)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_wides

_NIRVANAP_wides:

	pop af
	pop hl

	push hl
	push af

        ld (56111),hl
        ret
