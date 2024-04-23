IF !__CPU_RABBIT__ && !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_RABBIT__ && !__CPU_KC160__

SECTION code_l_sccz80_far
PUBLIC  lp_guchar

EXTERN  __far_start
EXTERN  __far_end
EXTERN  __far_page


; Entry ehl = extended address
;        hl = sign extended char
lp_guchar:
    call   __far_start
    ex     af,af
    ld     bc,hl
    call    __far_page
    ; hl = physical address
    ld      l,(hl)
    ld      h,0
    ex      af,af
    call    __far_end 
    ret
ENDIF
