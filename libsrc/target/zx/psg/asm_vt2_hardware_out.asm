; ZX Implementation of the hardware out for VortexTracker/z80

	SECTION	code_psg

	PUBLIC	asm_vt_hardware_out
	PUBLIC	asm_vt_hardware_out_A0
	EXTERN	asm_VT_AYREGS


asm_vt_hardware_out:
        XOR A
asm_vt_hardware_out_A0:
ROUT_A0:
        LD DE,$FFBF
        LD BC,$FFFD
        LD HL,asm_VT_AYREGS
LOUT:
        OUT (C),A
        LD B,E
        OUTI
        LD B,D
        INC A
        CP 13
        JR NZ,LOUT
        OUT (C),A
        LD A,(HL)
        AND A
        RET M
        LD B,E
        OUT (C),A
        RET
