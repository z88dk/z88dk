
	SECTION	code_psg

IF !__CPU_INTEL__ && !__CPU_GBZ80__

    PUBLIC  ay_vt2_play
    PUBLIC  _ay_vt2_play
    PUBLIC  ay_vt2_start
    PUBLIC  _ay_vt2_start
    PUBLIC  ay_vt2_stop
    PUBLIC  _ay_vt2_stop

    EXTERN  asm_VT_PLAY
    EXTERN  asm_VT_MUTE

ay_vt2_play:
_ay_vt2_play:
    push    ix
    ld      a,(__ay_vt2_play_enabled)
    and     a
    call    nz,asm_VT_PLAY
    pop     ix
    ret

ay_vt2_start:
_ay_vt2_start:
    ld      a,1
    ld      (__ay_vt2_play_enabled),a
    ret

ay_vt2_stop:
_ay_vt2_stop:
    push    ix
    xor     a
    ld      (__ay_vt2_play_enabled),a
    call	asm_VT_MUTE
    pop     ix
    ret



    SECTION	data_psg

__ay_vt2_play_enabled:	defb	1

ENDIF

