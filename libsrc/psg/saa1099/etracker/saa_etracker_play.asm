IF __CPU_Z80__ | __CPU_Z80N__
    SECTION code_clib
    PUBLIC  saa_etracker_play
    PUBLIC  _saa_etracker_play
    EXTERN  asm_etracker_play

; Etracker uses mainset, ix and af'
; Save the non-mainset registers for ease of integration
saa_etracker_play:
_saa_etracker_play:
    push    ix
    ex      af,af
    push    af
    ex      af,af
    call    asm_etracker_play
    ex      af,af
    pop     af
    ex      af,af
    pop     ix
    ret
ENDIF
