;
; Graphics console (mode 1): clear the whole screen to the paper colour
;
    SECTION code_clib
    PUBLIC  __mz2500_gfxcon_cls
    EXTERN  __mz2500_gfx_clear
    EXTERN  __mz2500_con_paper

__mz2500_gfxcon_cls:
    ld      a, (__mz2500_con_paper)
    jp      __mz2500_gfx_clear

