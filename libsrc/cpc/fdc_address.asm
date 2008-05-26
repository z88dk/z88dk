;
;       Amstrad CPC library
;       Internal function to get the disk address in BC
;
;       $Id: fdc_address.asm,v 1.1 2008-05-26 06:38:08 stefano Exp $
;

        XLIB    disk_address
        
        LIB	cpc_fdc


.disk_address
	jp	setup
	ret
	
.setup
	ld	a,1		; SMC: ld bc,nn
	ld	(disk_address),a
	call	cpc_fdc
	ld	bc,$fbf6
	ld	(disk_address+2),bc	; SMC
	dec	l
	dec	l
	ret	z
	
	ld	bc,$fb7e
	ld	(disk_address+2),bc	; SMC
	ret
