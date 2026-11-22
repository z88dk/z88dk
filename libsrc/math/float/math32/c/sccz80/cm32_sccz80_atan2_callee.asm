
SECTION code_fp_math32
PUBLIC cm32_sccz80_atan2_callee

EXTERN _m32_atan2f


IF __CPU_GBZ80__

; AF-safe bubble (pop af would drop F bits 3–0). No ex (sp),hl.

.cm32_sccz80_atan2_callee
    ld b,0
.atan2_bub
    ld a,b
    cp 8
    jr Z,atan2_call
    push bc
    ld hl,sp+2
    ld c,a
    ld b,0
    add hl,bc
    ld e,(hl+)
    ld d,(hl+)
    ld c,(hl+)
    ld b,(hl)
    ld (hl),d
    dec hl
    ld (hl),e
    dec hl
    ld (hl),b
    dec hl
    ld (hl),c
    pop bc
    ld a,b
    add a,2
    ld b,a
    jr atan2_bub

.atan2_call
    call _m32_atan2f
    add sp,8
    ret

ELIF __CPU_8085__

; AF-safe: pop af of a float clears F bit 3 on 8085. Word rotate like pow.

.cm32_sccz80_atan2_callee
    ld de,sp+0
    ld hl,(de)
    ld bc,hl                    ; BC = ret_outer
    ld de,sp+2
    ld hl,(de)
    ld de,sp+0
    ld (de),hl
    ld de,sp+4
    ld hl,(de)
    ld de,sp+2
    ld (de),hl
    ld de,sp+6
    ld hl,(de)
    ld de,sp+4
    ld (de),hl
    ld de,sp+8
    ld hl,(de)
    ld de,sp+6
    ld (de),hl
    ld hl,bc
    ld de,sp+8
    ld (de),hl
    call _m32_atan2f
    pop bc
    pop bc
    pop bc
    pop bc
    ret

ELIF __CPU_INTEL__

; 8080: no ld hl,(de). Same AF-safe adjacent-word bubble as pow.

.cm32_sccz80_atan2_callee
    ld b,0
.atan2_bub
    ld a,b
    cp 8
    jp Z,atan2_call
    push bc
    ld hl,sp+2                  ; frame after saved step (8080: not ld de,sp+*)
    ld e,a
    ld d,0
    add hl,de
    ld de,(hl+)
    push de
    ld e,(hl+)
    ld d,(hl)
    ex (sp),hl
    ex de,hl
    ex (sp),hl
    ld (hl-),d
    ld (hl-),e
    pop de
    ld (hl-),d
    ld (hl),e
    pop bc
    ld a,b
    add a,2
    ld b,a
    jp atan2_bub

.atan2_call
    call _m32_atan2f
    pop bc
    pop bc
    pop bc
    pop bc
    ret

ELSE

cm32_sccz80_atan2_callee:
    pop hl      ; return
    pop bc      ; RHS
    pop de
    pop af      ; LHS
    ex (sp),hl  ; return to stack

    push de     ; RHS
    push bc
    push hl     ; LHS
    push af

    call _m32_atan2f
    pop af
    pop af
    pop af
    pop af
    ret

ENDIF
