; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_chars(unsigned char *addr)

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_chars

EXTERN asm_NIRVANAM_chars

_NIRVANAM_chars:

	pop af
	pop hl

	push hl
	push af

        jp asm_NIRVANAM_chars
