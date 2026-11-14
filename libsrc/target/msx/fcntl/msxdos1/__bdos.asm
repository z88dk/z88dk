
    SECTION code_driver

    PUBLIC  __bdos

; The Bondwell2 uses ix during bdos calls.
;
; This will have the unfortunate effect of
; breaking SDCC based compilations since ix is used
; as the framepointer
;
; So redefine the internal __bdos symbol to save
; and restore ix - this needs to be generic across
; all z80 CP/M platforms
;
; On MSX-DOS the wrapper must save iy as well: the
; MSX-DOS 1.x kernel destroys iy on every bdos call
; (and ix on file calls), measured on the genuine
; MSX-DOS 1.03 kernel. No bdos function used by the
; fcntl layer returns a result in ix or iy (results
; come back in a), so an unconditional save/restore
; of both registers is safe here.

IF __CPU_INTEL__
	defc	__bdos = 5
ELSE
__bdos:
	push	ix
	push	iy
	call	5
	pop	iy
	pop	ix
	ret
ENDIF
