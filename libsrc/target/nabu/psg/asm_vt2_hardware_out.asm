; Vortextracker II player
;
; Hardware output routine for NabuPC
;
;

	SECTION	code_psg

	PUBLIC	asm_vt_hardware_out
        PUBLIC  asm_vt_hardware_out_A0

	EXTERN	asm_VT_AYREGS


asm_vt_hardware_out:
    XOR     A
asm_vt_hardware_out_A0:
    ld      b,a
    LD      HL,asm_VT_AYREGS+7
    ld      a,@00111111
    and     (hl)
    or      @01000000
    ld      (hl),a
    ld      a,b
    LD      bC,$41
    LD      HL,asm_VT_AYREGS
LOUT:
    OUT     (C),A
    DEC     C
    OUTI
    ld      b,0
    INC     C
    INC     A
    CP      13
    JR      NZ,LOUT
    OUT     (C),A
    LD      A,(HL)
    AND     A
    RET     M
    DEC     C
    OUT     (C),A
    RET


    ; Disable all interrupts to start off with
    ; This is called before userland has a chance to enable them...
    SECTION code_crt_init
    EXTERN  nabu_set_interrupts

    ld     l,0
    call   nabu_set_interrupts
