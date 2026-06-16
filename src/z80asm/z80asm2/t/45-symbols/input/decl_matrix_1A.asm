; ============================================================
;  SYMBOL DECLARATION / DEFINITION EXHAUSTIVE TEST MATRIX
;  Covers:
;    - extern / public / global / none
;    - definition before / between / after
;    - redeclaration combinations
;    - multi-step sequences
;    - correct error messages
; ============================================================

; ============================================================
;  SECTION 1 - BASIC EXTERN BEHAVIOR
; ============================================================

; 1A - extern before definition (allowed)
    extern x
x:  nop
