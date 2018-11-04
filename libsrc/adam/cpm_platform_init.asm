; ADAM Platform initialisation code
;

	SECTION	code_clib
	PUBLIC	cpm_platform_init

cpm_platform_init:
	; Initialise the NMI handler - catches the VDP interrupt
        ld      hl,0x45ed
        ld      (0x66),hl
	ret
