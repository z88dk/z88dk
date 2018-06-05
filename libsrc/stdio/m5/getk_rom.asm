;
;	SORD M5 Stdio
;
;	getk() Read key status
;
;	Stefano Bodrato - 18/5/2001
;
;
;	$Id: getk.asm,v 1.8+ (GIT imported) $
;

        SECTION code_clib
	PUBLIC	getk_rom
	PUBLIC	_getk_rom
	EXTERN	msxbios

	INCLUDE "target/m5/def/m5bios.def"

.getk_rom
._getk_rom
;        ld      ix,ACECH0
;       call    msxbios
	call	$966
	call	$8da
	ld	hl,0
	and	a
	ret	z

IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF
	ld	l,a
	ret
