SECTION code_clib
SECTION code_l

PUBLIC __z80_rst_20h

EXTERN l_ret

defc __z80_rst_20h = l_ret

; weak default for target/crt_jump_vectors_z80.inc
