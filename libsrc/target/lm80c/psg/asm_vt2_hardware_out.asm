; LM80C Implementation of the hardware out for VortexTracker/z80

	SECTION	code_psg

	PUBLIC	asm_vt_hardware_out
	PUBLIC	asm_vt_hardware_out_A0
	EXTERN	asm_VT_AYREGS
        EXTERN  PSG_AY_REG
        EXTERN  PSG_AY_DATA


asm_vt_hardware_out:
        XOR A
asm_vt_hardware_out_A0:
ROUT_A0:
	; Port b = read, port a = write
        LD HL,asm_VT_AYREGS+7
	ld	a,(hl)
	and	@00111111
	or	@01000000
	ld	(hl),a
        LD DE,+(PSG_AY_REG * 256) + PSG_AY_DATA
        LD BC,+PSG_AY_REG
        LD HL,asm_VT_AYREGS
LOUT:
        OUT (C),A
        LD c,E
        OUTI
        LD c,D
        INC A
        CP 13
        JR NZ,LOUT
        OUT (C),A
        LD A,(HL)
        AND A
        RET M
        LD c,E
        OUT (C),A
        RET
