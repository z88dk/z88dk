; Test helper: return IX, so a test can prove a library routine left the
; caller's index register (frame pointer in 80cc/sdcc fp code) untouched.

    SECTION code_clib
    PUBLIC  ix_get
    PUBLIC  _ix_get

ix_get:
_ix_get:
    push    ix
    pop     hl
    ret
