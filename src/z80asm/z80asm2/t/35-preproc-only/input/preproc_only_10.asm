; macros
MACRO PRINT ch
    ld a, ch
    rst $10
ENDM
    PRINT 'h'
    PRINT 'e'
    PRINT 'l'
    PRINT 'l'
    PRINT 'o'
