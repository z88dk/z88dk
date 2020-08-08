

SECTION code_fp_am9511
PUBLIC cam32_sccz80_pow

EXTERN cam32_sccz80_switch_arg
EXTERN asm_am9511_pow

.cam32_sccz80_pow
    call cam32_sccz80_switch_arg
    jp asm_am9511_pow
