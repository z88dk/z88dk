; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_chars(unsigned char *addr)

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_chars

EXTERN asm_NIRVANAP_chars

_NIRVANAP_chars:

	pop af
	pop hl

	push hl
	push af

        jp asm_NIRVANAP_chars
