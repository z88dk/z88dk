
    SECTION code_clib
    PUBLIC  saa_etracker_play
    PUBLIC  _saa_etracker_play
    EXTERN  asm_etracker_play

    defc saa_etracker_play = asm_etracker_play
    defc _saa_etracker_play = saa_etracker_play
