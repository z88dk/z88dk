; $Id: synth_phase.asm $
;
; Generic 1 bit sound functions
; by Stefano Bodrato, 2021
;
; set up the frequency shifting parameters for synth_play
;

  IF    !__CPU_GBZ80__
        SECTION code_clib

        PUBLIC  synth_phase
        PUBLIC  _synth_phase

        PUBLIC  synth_phase_1
        PUBLIC  _synth_phase_1
        PUBLIC  synth_phase_2
        PUBLIC  _synth_phase_2
        PUBLIC  synth_phase_3
        PUBLIC  _synth_phase_3
        PUBLIC  synth_phase_4
        PUBLIC  _synth_phase_4


synth_phase:
_synth_phase:
        ld      a, h
    IF  __CPU_INTEL__
        rrca
        rrca
        rrca
        rrca
        and     15
    ELSE
        srl     a
        srl     a
        srl     a
        srl     a
    ENDIF
        ld      (synth_phase_1), a
        ld      a, h
        and     $0f
        ld      (synth_phase_2), a
        ld      a, l
    IF  __CPU_INTEL__
        rrca
        rrca
        rrca
        rrca
        and     15
    ELSE
        srl     a
        srl     a
        srl     a
        srl     a
    ENDIF
        ld      (synth_phase_3), a
        ld      a, l
        and     $0f
        ld      (synth_phase_4), a
        ret



        SECTION data_clib

_synth_phase_1:
synth_phase_1:
        defw    1

_synth_phase_2:
synth_phase_2:
        defw    2

_synth_phase_3:
synth_phase_3:
        defw    3

_synth_phase_4:
synth_phase_4:
        defw    4



  ENDIF
