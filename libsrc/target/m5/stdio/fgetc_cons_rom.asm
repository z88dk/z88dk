;
;	SORD M5 Stdio
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fgetc_cons.asm,v 1.7+ (now on GIT) $
;

        SECTION code_clib
	PUBLIC	fgetc_cons_rom
	PUBLIC	_fgetc_cons_rom
	EXTERN	msxbios

	INCLUDE "target/m5/def/m5bios.def"

.fgetc_cons_rom
._fgetc_cons_rom
	call	WTKDTC

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	h,0
	ld	l,a
	ret
