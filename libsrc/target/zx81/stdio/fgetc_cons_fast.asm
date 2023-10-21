;
;	ZX81 Stdio
;
;	getkey() Wait for keypress
;	FAST mode, it takes care of polling the ROM
;	for keeping the display visible
;
;	Stefano Bodrato - Sep. 2023
;
;
;	$Id: fgetc_cons_fast.asm $
;

	SECTION code_clib

	PUBLIC	fgetc_cons_fast
	PUBLIC	_fgetc_cons_fast
	EXTERN	zx81toasc

	EXTERN    restore81

.fgetc_cons_fast
._fgetc_cons_fast
	call	restore81
	xor		a
	ld		($4025),a	; LAST_K.   The ZX80 worked directly on CH_ADD
.fgetc_cons2
	ld		a,($4025)
	ex		af,af

;	call $0196  ; zx80

IF FORlambda
	EXTERN  __lambda_syncvideo
	call	__lambda_syncvideo
ELSE
	call	631     ; $277, equivalent to $229 on a ZX80.
					; Forces a whole display retrace skipping a bit of code to reduce glitches
ENDIF

	ld      a,($4025)
	ld		e,a
	ex		af,af
	cp		e
	jr		z,fgetc_cons2
	
;	jp		zx80_decode_keys

	ld      bc,($4025)

IF FORlambda
	EXTERN  __lambda_decode
	call	__lambda_decode
ELSE
	call	1981
ENDIF

	call	zx81toasc
	ld	l,a
	ld	h,0
	ret

