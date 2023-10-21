
SECTION code_graphics

PUBLIC getmaxx
PUBLIC _getmaxx
PUBLIC ___getmaxx

EXTERN __aquarius_mode

defc _getmaxx = getmaxx
defc ___getmaxx = getmaxx

getmaxx:
    ld      a,(__aquarius_mode)
    ld      hl,79
    bit     2,a
    ret     z
    ld      hl,319
    ret
