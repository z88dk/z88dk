;ZXVGS specific functions

;020128 created by Yarek


	PUBLIC	opensound

;int opensound(int device,int mode)
;returns opened mode (0 means the device is closed)

.opensound
	POP	BC
	POP	DE	;mode
	POP	HL	;device
	PUSH	HL
	PUSH	DE
	PUSH	BC
	LD	D,L
	RST	8
	DEFB	$A5
	LD	L,E

;temporary for ZXVGS 0.29
;	LD	L,A
;remove it later

	LD	H,0
	RET
