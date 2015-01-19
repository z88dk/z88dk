;
;	ZX80 Stdio
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - Dec 2011
;
;
;	$Id: fgetc_cons.asm,v 1.3 2015-01-19 01:33:22 pauloscustodio Exp $
;

	PUBLIC	fgetc_cons
	EXTERN		zx80_decode_keys

.fgetc_cons
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
