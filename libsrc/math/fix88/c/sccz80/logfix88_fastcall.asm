    SECTION code_clib

    PUBLIC  logfix88_fastcall
    PUBLIC  _logfix88_fastcall

    EXTERN  asm_fix88_log

    defc    logfix88_fastcall = asm_fix88_log
    defc    _logfix88_fastcall = asm_fix88_log