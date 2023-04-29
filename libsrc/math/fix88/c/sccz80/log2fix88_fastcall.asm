    SECTION code_clib

    PUBLIC  log2fix88_fastcall
    PUBLIC  _log2fix88_fastcall

    EXTERN  asm_fix88_log2

    defc    log2fix88_fastcall = asm_fix88_log2
    defc    _log2fix88_fastcall = asm_fix88_log2