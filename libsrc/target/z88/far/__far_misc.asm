

SECTION code_l_sccz80

PUBLIC  __far_start
PUBLIC  __far_end


__far_start:
    ld       a,($4d1)
    ret

__far_end:
    ld      ($04d1),a
    out     ($d1),a
    ret


    
