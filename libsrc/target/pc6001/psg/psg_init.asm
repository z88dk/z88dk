;
;	PC-6001 specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: psg_init.asm,v 1.3 2016-06-10 21:13:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	psg_init
	PUBLIC	_psg_init
	
psg_init:
_psg_init:

	ld	e,@01010101
	xor a 	; R0: Channel A frequency low bits
	call outpsg

	ld	e,a

	ld d,12
psg_iniloop:
	inc a	; R1-13: set all to 0 but 7 and 11
	;cp 7
	;jr z,skip
	;cp 11
	;jr z,skip
	call outpsg
skip:
	dec d
	jr	nz,psg_iniloop

	ld	e,@11111000	; R7: Channel setting.  Enable sound channels ABC and input on ports A and B
	ld	a,7
	call outpsg

	ld	e,@00001011	; R11: Envelope
	ld	a,11


outpsg:
    LD	BC,$A0
	OUT	(C),a

	inc c
	OUT	(C),e
	ret

; register  PC-6001  AY-3-8910  Operation 
;----------------------------------------------
; $00~$05   R0~R5    R0~R5      Tone Generator Control 
; $06       R6       R6         Noise Generator Control 
; $07       R7       R7         Mixer Control-I/O Enable 
; $08~$0A   R8~R10   R10~R12    Amplitude Control 
; $0B~$0C   R11~R12  R13~R14    Envelop Period Control 
; $0D       R13      R15        Envelop Shape/Cycle Control 

