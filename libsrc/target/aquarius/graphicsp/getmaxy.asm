
SECTION code_graphics

PUBLIC getmaxy
PUBLIC _getmaxy
PUBLIC ___getmaxy

EXTERN __aquarius_mode

defc _getmaxy = getmaxy
defc ___getmaxy = getmaxy

getmaxy:
    ld      a,(__aquarius_mode)
    ld      hl,47       ;We use 80x48 for the + since it looks better
    bit     2,a
    ret     z
    ld      hl,199
    ret
