;
;	ZX80 Stdio
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - Dec 2011
;
;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons
	EXTERN		zx80_decode_keys

.fgetc_cons
._fgetc_cons
	ld      iy,16384	; no ix/iy swap here
	;call	restore81
	xor		a
	ld		($4026),a
.fgetc_cons2
	ld		a,($4026)
	ex		af,af
	;call $013C
	call $0196
	ld      a,($4026)
	ld		e,a
	ex		af,af
	cp		e
	jr		z,fgetc_cons2
	
	jp		zx80_decode_keys
