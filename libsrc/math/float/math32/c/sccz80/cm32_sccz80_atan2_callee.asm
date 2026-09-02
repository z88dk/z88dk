
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
