;
;	Sharp MZ-2500 graphics: switch to the graphics mode and clear it to the paper colour
;
;	void clg(void);
;
    SECTION code_clib
    PUBLIC  clg
    PUBLIC  _clg
    EXTERN  mz2500_gfx_init
    EXTERN  __mz2500_gfx_clear
    EXTERN  __mz2500_gfx_paper

clg:
_clg:
    call    mz2500_gfx_init
    ld      a, (__mz2500_gfx_paper)
    jp      __mz2500_gfx_clear
