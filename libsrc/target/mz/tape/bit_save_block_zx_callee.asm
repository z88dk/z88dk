;
;      ZX Spectrum style Tape save routine
;
;      int __CALLEE__ bit_save_block_zx_callee(void *addr, size_t len, unsigned char type)
;


SECTION  code_clib

PUBLIC bit_save_block_zx_callee
PUBLIC _bit_save_block_zx_callee
PUBLIC asm_bit_save_block_zx

EXTERN mztape_motor_on
EXTERN mztape_motor_off

EXTERN mz_type



.bit_save_block_zx_callee
._bit_save_block_zx_callee

	pop hl
	pop bc
	ld a,c
	pop de
	pop bc
	push hl

; enter : ix = addr
;         de = len
;          a = type

.asm_bit_save_block_zx
	
	di


	push ix
	push bc
	pop ix


	EXX
	LD     BC,$6CF
	EXX


	push af

        ; Probe the MONITOR to detect Sharp MZ model.
        ; $26 would probably identify the MZ80K.
        
        ld a,($10)
        cp $24          ; Are we on a MZ700 ?
        jr z,no_patch
        cp $58          ; Are we on a MZ800 ?
        jr z,no_patch
 
;		push hl
;		push de
;		call mz_type
;		ld a,l
;		pop de
;		pop hl
;		
;		cp 2		; MZ-700, MZ-800, MZ-1500 ?
;		jr z,no_patch

        ; Then, we assume it is a 2mhz system (MZ80A..)
        LD      A,93
        LD      (PLAY_DATA_LEAD+1),a
        LD      A,26
        LD      (PLAY_DATA_SYNC1+1),a
        LD      (PLAY_DATA_SYNC1b+1),a
        LD      A,31
        LD      (PLAY_DATA_SYNC2+1),a
		INC     A
		INC     A
        LD      (PLAY_DATA_SYNC2b+1),a
        LD      (PLAY_DATA_SYNC2c+1),a
		INC     A
        LD      (PLAY_DATA_BIT0+1),a
		INC     A
		INC     A
        LD      (PLAY_DATA_BIT0b+1),a

.no_patch

        ; MOTOR ON
        CALL mztape_motor_on
	
	pop af

		CALL    SA_BYTES
		CALL	mztape_motor_off

	pop ix
	ei
	ret



.SA_BYTES
        LD      HL,$1F80		; This constant will give a leader of about 5 seconds for a 'header'.
        BIT     7,A				; Jump forward if saving a header.
        JR      Z,SA_FLAG

        LD      HL,$0C98		; This constant will give a leader of about 2 seconds for a program/data block.

.SA_FLAG
        EX      AF,AF'			; The flag is saved.
        INC     DE				; The 'length' is incremented and the 'base address' reduced to allow for the flag.
        DEC     IX

		ld  b,2					; Give a short value to B to avoid jams in SA_LEADER
		ld	a,3            		; MIC on

.SA_LEADER
        DJNZ    SA_LEADER		; The main timing period.

		ld      (0xE003),a
        EXX
		xor 6
        OUT    (C),A
		xor 6
        EXX
		xor  1	; MIC on<>off

PLAY_DATA_LEAD:
        LD      B,163			; The main timing constant.
        DEC     L				; Decrease the low counter.
        JR      NZ,SA_LEADER	; Jump back for another pulse.

        DEC     B
        DEC     H
        JP      P,SA_LEADER


; A sync pulse is now sent.
;-----------------------------
.PLAY_DATA_SYNC1
        LD       B,46			; MIC off for 667 T states from 'OUT to OUT'.
.SA_SYNC_1
        DJNZ    SA_SYNC_1

		ld      a,3				; MIC on
		ld      (0xE003),a
        EXX
        OUT    (C),A
        EXX

		xor  1	; MIC off

.PLAY_DATA_SYNC2
        LD      B,54			; MIC on for 735 T States from 'OUT to OUT'.
.SA_SYNC_2
        DJNZ    SA_SYNC_2

		ld      (0xE003),a		; MIC off
        EXX
        OUT    (C),A
        EXX

.PLAY_DATA_SYNC2b
		LD      B,58
		ld      c,a				; 'MIC off'
		
		xor  1
		
		
        EX      AF,AF'			; Fetch the flag and pass it to the L register for 'sending'.
        LD      L,A
        JP      SA_START		; Jump forward into the saving loop.

;-----------------------------
.SA_LOOP
        LD      A,D				; The 'length' counter is tested and the jump taken when it has reached zero.
        OR      E
        JR      Z,SA_PARITY

        LD      L,(IX+$00)		; Fetch the next byte that is to be saved.

.SA_LOOP_PARITY
        LD      A,H				; Fetch the current 'parity'.
        XOR     L				; Include the present byte.

.SA_START
        LD      H,A				; Restore the 'parity'. Note that on entry here the 'flag' value initialises 'parity'.
		ld      a,3             ; MIC on

        SCF						; Set the carry flag. This will act as a 'marker' for the 8 bits of a byte.
        JP      SA_BYTE

;------------------------
.SA_PARITY
        LD      L,H	
        JR      SA_LOOP_PARITY

;------------------------
.SA_BIT_2
        LD      A,C				;  Come here on the second pass and fetch 'MIC off and yellow'.
        BIT     7,B				; Set the zero flag to show 'second pass'.

.SA_BIT_1
        DJNZ    SA_BIT_1		; The main timing loop; always 801 T states on a second pass.

        JR      NC,SA_OUT		; Jump, taking the shorter path, if saving a '0'.

.PLAY_DATA_BIT0b
        LD      B,65            ; However if saving a '1' then add 855 T states.

.SA_SET
        DJNZ    SA_SET

;------------------------
.SA_OUT
		ld      (0xE003),a
        EXX
        OUT    (C),A
        EXX

.PLAY_DATA_BIT0
        LD      B,61
        JR      NZ,SA_BIT_2

        DEC     B

        XOR     A				; Clear the carry flag and set A to hold..
		ld      a,3				; MIC on

.SA_BYTE
        RL      L				; Move bit 7 to the carry and the 'marker' leftwards.
        JP      NZ,SA_BIT_1		; Save the bit unless finished with the byte.

        DEC     DE
        INC     IX
.PLAY_DATA_SYNC1b
        LD      B,46			; Set the timing constant for the first bit of the next byte.

;        LD      A,$7F			; Return (to SA_LD_RET) if the BREAK key is being pressed.
;        IN      A,($FE)
;        RRA
;        RET     NC

        LD      A,D				; test the 'counter' and jump back..
        INC     A				; ..even if it has reached zero (so as to send the 'parity' byte).
        JP      NZ,SA_LOOP

.PLAY_DATA_SYNC2c
        LD      B,58			; Exit when the 'counter' reaches +FFFF. But first give a short delay.

.SA_DELAY
        DJNZ    SA_DELAY
        RET

