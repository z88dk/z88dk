; Noop for disabled screenmodes

SECTION rodata_clib
PUBLIC __vdp_mode_noop_term

EXTERN  l_ret

__vdp_mode_noop_term:
    defw    l_ret
    defw    l_ret
    defw    l_ret
