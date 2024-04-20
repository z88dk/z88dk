

SECTION code_l_sccz80

PUBLIC  __far_init
PUBLIC  __far_reset


__far_init:
    ld       a,($4d1)
    ret

__far_reset:
    ld      ($04d1),a
    out     ($d1),a
    ret


    
