;
; gbz80 sccz80 callee float read (no exx, never pop af for return).
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fsread1_callee


.cm32_sccz80_fsread1_callee
    pop bc                      ; my return
    pop de                      ; ret1
    pop hl                      ; LSW
    push hl                     ; park LSW; HL↔DE without ex (56c)
    ld h,d
    ld l,e                      ; HL = ret1
    pop de                      ; DE = LSW
    ; open-code ex (sp),hl — preserve BC/DE (helper is 148c)
    push de
    ld d,h
    ld e,l                      ; DE = ret1
    ld hl,sp+2                  ; &MSW
    ld a,(hl)
    ld (hl),e
    ld e,a
    inc hl
    ld a,(hl)
    ld (hl),d
    ld h,a
    ld l,e                      ; HL = MSW; (sp+2) = ret1
    pop de                      ; DE = LSW
    push hl                     ; DE=MSW, HL=LSW
    ld h,d
    ld l,e
    pop de
    push bc
    ret
