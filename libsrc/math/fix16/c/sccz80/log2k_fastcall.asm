    SECTION code_clib

    PUBLIC  log2k_fastcall
    PUBLIC  _log2k_fastcall

    EXTERN  asm_fix16_log2

    defc    log2k_fastcall = asm_fix16_log2
    defc    _log2k_fastcall = asm_fix16_log2