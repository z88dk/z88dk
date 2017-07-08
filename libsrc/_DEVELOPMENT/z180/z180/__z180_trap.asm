SECTION code_clib
SECTION code_l

PUBLIC __z180_trap

EXTERN __Leave

defc __z180_trap = __Leave

; weak default for target/crt_jump_vectors_z180.inc
