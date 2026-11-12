;
; The console's pens (0-3: see mz800_gfx_init for the palette)
;
    MODULE  conio_vars
    SECTION data_clib

    PUBLIC  __mz800_con_ink
    PUBLIC  __mz800_con_paper

__mz800_con_ink:    defb    3           ; white on black
__mz800_con_paper:  defb    0           ; (the two are read together as a word: ink low)
