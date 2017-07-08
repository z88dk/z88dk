SECTION code_clib
SECTION code_l

PUBLIC __z80_nmi

EXTERN l_retn

defc __z80_nmi = l_retn

; weak default for target/crt_jump_vectors_z80.inc
