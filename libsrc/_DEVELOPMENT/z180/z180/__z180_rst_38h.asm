SECTION code_clib
SECTION code_l

PUBLIC __z180_rst_38h

EXTERN l_ei_reti

defc __z180_rst_38h = l_ei_reti

; weak default for target/crt_jump_vectors_z180.inc
