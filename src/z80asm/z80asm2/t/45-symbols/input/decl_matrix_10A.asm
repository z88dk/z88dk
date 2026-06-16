; ============================================================
;  SECTION 10 - FORWARD REFERENCE TESTS
;  These verify that the assembler correctly resolves symbols
;  defined later in the file, with and without declarations.
; ============================================================

; 10A - forward reference without declaration (allowed)
    ld a,(x)
x:  nop
