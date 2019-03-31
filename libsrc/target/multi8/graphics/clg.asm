;
; Switch to graphics (hires) mode and clear screen
;

	SECTION	  code_clib
        PUBLIC    clg
        PUBLIC    _clg

	EXTERN	generic_console_ioctl

        INCLUDE "ioctl.def"

.clg
._clg
	ld	hl,2
	push	hl
	ld	hl,0
	add	hl,sp
	ex	de,hl
	ld	a,IOCTL_GENCON_SET_MODE
	call	generic_console_ioctl
	pop	hl	
        ret
