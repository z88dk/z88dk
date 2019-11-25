	SECTION	code_driver

	PUBLIC	asm_switch_data

	GLOBAL	copy_vram
	GLOBAL	y_table


asm_switch_data:
        PUSH    DE              ; Save src
        PUSH    HL              ; Save dst
        LD      L,B
        SLA     L
        SLA     L
        SLA     L
        LD      H,0x00
        ADD     HL,HL
        LD      D,H
        LD      E,L

        LD      HL,y_table
        SLA     C
        SLA     C
        SLA     C
        LD      B,0x00
        ADD     HL,BC
        ADD     HL,BC
        LD      B,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,B
        ADD     HL,DE

        LD      B,H             ; BC = src
        LD      C,L
        POP     HL              ; HL = dst
        PUSH    BC              ; Save dst
        LD      A,H
        OR      L
        JR      Z,switch_1
        LD      DE,0x10
        CALL    copy_vram
switch_1:
        POP     HL              ; HL = dst
        POP     BC              ; BC = src
        LD      DE,0x10
        CALL    copy_vram
        RET
