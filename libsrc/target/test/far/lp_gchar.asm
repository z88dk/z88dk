IF !__CPU_RABBIT__ && !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__

SECTION code_l_sccz80
PUBLIC  lp_gchar

EXTERN  __far_init
EXTERN  __far_reset
EXTERN  __far_page


; Entry ehl = extended address
;        hl = sign extended char
lp_gchar:
    call   __far_init
    ex     af,af
    ld     bc,hl
    call    __far_page
    ; hl = physical address
    ld      l,(hl)
    ld      h,0
    ex      af,af
    call    __far_reset
    ret
ENDIF
