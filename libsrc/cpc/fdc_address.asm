;
;       Amstrad CPC library
;       Internal function to get the disk address in BC
;
;       $Id: fdc_address.asm,v 1.3 2016-06-10 21:12:36 dom Exp $
;

        SECTION   code_clib
        PUBLIC    disk_address
        
        EXTERN	cpc_fdc


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
