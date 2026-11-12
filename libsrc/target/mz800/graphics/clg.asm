;
;	Sharp MZ-800 graphics: switch to the graphics mode and clear it to the paper pen
;
;	void clg(void);
;
    SECTION code_clib
    PUBLIC  clg
    PUBLIC  _clg
    EXTERN  mz800_gfx_init
    EXTERN  __mz800_gfx_clear
    EXTERN  __mz800_con_paper

clg:
_clg:
    call    mz800_gfx_init
    ld      a, (__mz800_con_paper)
    jp      __mz800_gfx_clear
