;
;      Tape save routine
;
;      int __CALLEE__ tape_save_block_callee(void *addr, size_t len, unsigned char type)
;


PUBLIC tape_save_block_callee
PUBLIC _tape_save_block_callee
PUBLIC asm_tape_save_block

EXTERN __SYSVAR_BORDCR


.tape_save_block_callee
._tape_save_block_callee

	pop hl
	pop bc
	ld a,c
	pop de
	pop ix
	push hl

; enter : ix = addr
;         de = len
;          a = type

.asm_tape_save_block
		
		CALL    SA_BYTES
		
        LD       A,(__SYSVAR_BORDCR)
        AND     $38
        RRCA
        RRCA
        RRCA
        OUT     ($FE),A
        LD      A,$7F
        IN      A,($FE)
        RRA
        EI
		LD      HL,0
		RET     NC
		
		DEC     HL		; Error:  -1
		RET


.SA_BYTES
        LD      HL,$1F80
        BIT     7,A
        JR      Z,SA_FLAG

        LD      HL,$0C98

.SA_FLAG
        EX      AF,AF'
        INC     DE
        DEC     IX
        DI
        LD      A,$02
        LD      B,A

.SA_LEADER
        DJNZ    SA_LEADER

        OUT     ($FE),A
        XOR     $0E
        LD      B,$A4
        DEC     L
        JR      NZ,SA_LEADER

        DEC     B
        DEC     H
        JP      P,SA_LEADER

        LD       B,$2F

.SA_SYNC_1
        DJNZ    SA_SYNC_1

        OUT     ($FE),A
        LD      A,$0D
        LD      B,$37

.SA_SYNC_2
        DJNZ    SA_SYNC_2

        OUT     ($FE),A
        LD      BC,$3B0E
        EX      AF,AF'
        LD      L,A
        JP      SA_START

.SA_LOOP
        LD      A,D
        OR      E
        JR      Z,SA_PARITY

        LD      L,(IX+$00)

.SA_LOOP_PARITY
        LD      A,H
        XOR     L

.SA_START
        LD      H,A
        LD      A,$01
        SCF
        JP      SA_BYTE

.SA_PARITY
        LD      L,H
        JR      SA_LOOP_PARITY

.SA_BIT_2
        LD      A,C
        BIT     7,B

.SA_BIT_1
        DJNZ    SA_BIT_1

        JR      NC,SA_OUT

        LD      B,$42

.SA_SET
        DJNZ    SA_SET

.SA_OUT
        OUT     ($FE),A
        LD      B,$3E
        JR      NZ,SA_BIT_2

        DEC     B
        XOR     A
        INC     A

.SA_BYTE
        RL      L
        JP      NZ,SA_BIT_1

        DEC     DE
        INC     IX
        LD      B,$31
        LD      A,$7F
        IN      A,($FE)
        RRA
        RET     NC

        LD      A,D
        INC     A
        JP      NZ,SA_LOOP 

        LD      B,$3B

.SA_DELAY
        DJNZ    SA_DELAY
        RET




