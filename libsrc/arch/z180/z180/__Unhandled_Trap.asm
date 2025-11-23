SECTION code_crt_common

PUBLIC __Unhandled_Trap

EXTERN asm_abort

defc __Unhandled_Trap = asm_abort
