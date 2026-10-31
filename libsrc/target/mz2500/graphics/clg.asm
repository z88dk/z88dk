;
;	Sharp MZ-2500 graphics: switch to the graphics mode and clear it to the paper colour
;
;	void clg(void);
;
    SECTION code_clib
    PUBLIC  clg
    PUBLIC  _clg
    EXTERN  mz2500_gfx_init
    EXTERN  l_push_di
    EXTERN  l_pop_ei
    EXTERN  __mz2500_gfx_paper

clg:
_clg:
    call    mz2500_gfx_init
    call    l_push_di
    ld      a, 2
    out     ($b4), a
    in      a, ($b5)                    ; window 2 as it is now, to put back
    push    af
    ld      a, (__mz2500_gfx_paper)
    ld      c, a
    ld      b, $20                      ; the pages of the planes of screen A: $20, $22, $24, $26
plane_loop:
    ld      a, 2
    out     ($b4), a
    ld      a, b
    out     ($b5), a
    xor     a
    rrc     c                           ; the paper colour's bit for this plane
    jr      nc, filled
    cpl
filled:
    ld      hl, $4000
    ld      (hl), a
    ld      de, $4001
    push    bc
    ld      bc, 7999
    ldir
    pop     bc
    inc     b
    inc     b
    ld      a, b
    cp      $28
    jr      nz, plane_loop
    ld      a, 2
    out     ($b4), a
    pop     af
    out     ($b5), a
    call    l_pop_ei
    ret
