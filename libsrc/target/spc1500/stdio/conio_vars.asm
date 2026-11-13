;
; The console's pens (0-7: a pen is a colour: 1 blue, 2 red, 4 green)
;
    MODULE  conio_vars
    SECTION data_clib

    PUBLIC  __spc1500_con_ink
    PUBLIC  __spc1500_con_paper

__spc1500_con_ink:    defb    7           ; white on black
__spc1500_con_paper:  defb    0           ; (the two are read together as a word: ink low)
