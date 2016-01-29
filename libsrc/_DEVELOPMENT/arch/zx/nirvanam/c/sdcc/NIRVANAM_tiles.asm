; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_tiles(unsigned char *addr)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_tiles

_NIRVANAM_tiles:

	pop af
	pop hl

	push hl
	push af

        ld (57321),hl
        ret
