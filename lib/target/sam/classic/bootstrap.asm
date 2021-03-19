; 
; Disk bootstrap for the SAM coupe
;

	SECTION	BOOTSTRAP
	EXTERN	__DATA_END_tail

	org	$8000
	
	; TODO: Use UFIA calls to load into banked memory
	ld	hl,CRT_ORG_CODE
	ld	b, +((__DATA_END_tail - CRT_ORG_CODE) / 256) + 1
;	call	DISK_Load
	jp	CRT_ORG_CODE


