

SECTION code_fp_am9511
PUBLIC cam32_sccz80_pow

EXTERN cam32_sccz80_switch_arg, cam32_sccz80_readl
EXTERN asm_am9511_pow

.cam32_sccz80_pow
    call cam32_sccz80_switch_arg
    call cam32_sccz80_readl
    jp asm_am9511_pow
