
INCLUDE "config_private.inc"

SECTION rodata_common1_driver

PHASE   0xF700

PUBLIC asm_z180_trap
asm_z180_trap:
    ret

PUBLIC asm_error_handler_rst
asm_error_handler_rst:
    ret

PUBLIC asm_far_call_rst
asm_far_call_rst:
    ret

PUBLIC asm_am9511a_rst
asm_am9511a_rst:
    ret

PUBLIC asm_system_rst
asm_system_rst:
    ret

PUBLIC asm_fuzix_rst
asm_fuzix_rst:
    ret

DEPHASE
