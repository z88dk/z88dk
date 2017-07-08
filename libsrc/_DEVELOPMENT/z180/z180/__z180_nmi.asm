SECTION code_clib
SECTION code_l

PUBLIC __z180_nmi

EXTERN l_retn

defc __z180_nmi = l_retn

; weak default for target/crt_jump_vectors_z180.inc
