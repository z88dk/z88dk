; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_tiles(unsigned char *addr)

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_tiles

_NIRVANA_tiles:

	pop af
	pop hl

	push hl
	push af

        ld (64284),hl
        ret
