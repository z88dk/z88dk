    SECTION code_clib

    PUBLIC  logk_fastcall
    PUBLIC  _logk_fastcall

    EXTERN  asm_fix16_log

    defc    logk_fastcall = asm_fix16_log
    defc    _logk_fastcall = asm_fix16_log