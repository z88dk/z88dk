; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_tiles(unsigned char *addr)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_tiles

_NIRVANAP_tiles:

	pop af
	pop hl

	push hl
	push af

        ld (64284),hl
        ret
