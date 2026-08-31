;
; 8080 sccz80 callee float read (no exx, never pop af for return).
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fsread1_callee


.cm32_sccz80_fsread1_callee
    pop bc                      ; my return
    pop de                      ; ret1
    pop hl                      ; LSW
    ex de,hl                    ; DE=LSW, HL=ret1
    ex (sp),hl                  ; HL=MSW, (sp)=ret1
    ex de,hl                    ; DE=MSW, HL=LSW
    push bc
    ret
