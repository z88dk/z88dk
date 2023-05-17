;
;	Visual 1050 specific code
;
;	Stefano Bodrato - 2023
;
;
;	$Id: v1050_sendchar.asm $
;

	SECTION	code_clib
	PUBLIC	v1050_sendchar

.v1050_sendchar

;	ld c,l

; ..using the BIOS
;	ld   de,9	; shift ptr to CONOUT
;	ld   hl,(1)	; WBOOT (BIOS)
;	add  hl,de
;	jp   (hl)

; ..direct I/O
MDSPOT:
	IN   A,(86h)     ; [P_DISP_C]  GET STATUS
	AND  1           ; TEST BIT 0
	JR   Z,MDSPOT    ; WAIT IF IT IS

	ld   a,l         ; GET THE CHARACTER
	OUT	 (85h),A     ; [P_DISP_OUT]  AND PUT IN THE REG
	LD   A,0EH       ; STROBE
	OUT	 (87h),A     ; P_DISP_CONTROL..
	INC  A           ; STROBE OFF
	OUT	 (87h),A     ; P_DISP_CONTROL..

	ret
