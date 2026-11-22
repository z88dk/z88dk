;
; The console's colours, as pixel values (blue 1, red 2, green 4, intensity 8: see mz2500_gfx_init for the palette)
;
    MODULE  conio_vars
    SECTION data_clib

    PUBLIC  __mz2500_con_ink
    PUBLIC  __mz2500_con_paper

__mz2500_con_ink:   defb    15          ; white on black
__mz2500_con_paper: defb    0           ; (the two are read together as a word: ink low)
