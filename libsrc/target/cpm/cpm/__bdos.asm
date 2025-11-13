
	SECTION	code_driver

	PUBLIC	__bdos
	EXTERN	__cpm_base_address

; The Bondwell2 uses ix during bdos calls.
;
; This will have the unfortunate effect of
; breaking SDCC based compilations since ix is used
; as the framepointer
;
; So redefine the internal __bdos symbol to save
; and restore ix - this needs to be generic across
; all z80 CP/M platforms
IF __CPU_INTEL__
	defc	__bdos = __cpm_base_address+5
ELSE
__bdos:
	push	ix
	call	__cpm_base_address+5
	pop	ix
	ret
ENDIF

