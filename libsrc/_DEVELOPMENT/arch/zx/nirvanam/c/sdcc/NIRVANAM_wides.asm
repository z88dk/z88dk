; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_wides(unsigned char *addr)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_wides

_NIRVANAM_wides:

	pop af
	pop hl

	push hl
	push af

        ld (56489),hl
        ret
