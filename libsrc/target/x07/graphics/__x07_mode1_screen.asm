

SECTION bss_clib
PUBLIC  __x07_mode1_screen
PUBLIC  __x07_mode1_dirty

; Screen only takes up 12 columns
__x07_mode1_screen:
    defs    16 * 8 * 4

; A dirty flag for each UDC that we're going to use
__x07_mode1_dirty:
    defs    20 * 4
