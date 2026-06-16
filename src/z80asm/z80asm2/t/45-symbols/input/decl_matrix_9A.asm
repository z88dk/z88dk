; ============================================================
;  SECTION 9 -> SYMBOL USE TESTS
;  These verify that referencing a symbol triggers correct
;  undefined / defined behavior depending on declarations.
; ============================================================

; 9A -> use of undefined symbol (no declaration)
    ld a,(x)
