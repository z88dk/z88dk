

SECTION code_fp_am9511
PUBLIC cam32_sccz80_pow

EXTERN asm_switch_arg, asm_sccz80_readl
EXTERN asm_am9511_pow

.cam32_sccz80_pow
    call asm_switch_arg
    call asm_sccz80_readl
    jp asm_am9511_pow
