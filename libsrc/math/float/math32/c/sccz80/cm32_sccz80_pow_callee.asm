
SECTION code_fp_math32
PUBLIC cm32_sccz80_pow_callee

EXTERN _m32_powf

; sccz80 callee → non-callee _m32_powf.
; Z80: _m32_powf is SDCC (master stack reverse).
; 8085: _m32_powf is sccz80; AF-safe left-rotate bridge (no pop af of ret).
; Synthetics: memory index/source only via HL or DE (never BC).
; Post-inc/dec forms: ld r,(hl+)/(hl-), ld (hl-),r etc.

IFDEF __CPU_INTEL__

; sccz80 entry: SP = ret_outer, y(4), x(4)
; non-callee _m32_powf: SP = ret, y(4), x(4)
; Adjacent word swaps bubble ret_outer under the args.

.cm32_sccz80_pow_callee
    ld b,0
.pow_bub
    ld a,b
    cp 8
    jp Z,pow_call
    push bc                     ; save step
    ld de,sp+2                  ; DE -> frame (ret,y,x)
    ld hl,de
    ld e,a
    ld d,0
    add hl,de                   ; HL -> word[i]
    ld e,(hl+)
    ld d,(hl+)                  ; DE = word[i], HL -> word[i+1]
    push de                     ; save word[i]
    ld e,(hl+)
    ld d,(hl)                   ; DE = word[i+1], HL at high of word[i+1]
    ex (sp),hl                  ; HL = word[i], (sp) = &word[i+1].hi
    ex de,hl                    ; DE = word[i], HL = word[i+1]
    ex (sp),hl                  ; HL = &word[i+1].hi, (sp) = word[i+1]
    ld (hl-),d                  ; word[i+1] <- old word[i] (hi then lo)
    ld (hl-),e                  ; HL -> word[i].hi
    pop de                      ; DE = old word[i+1]
    ld (hl-),d                  ; word[i] <- old word[i+1]
    ld (hl),e
    pop bc                      ; restore step
    ld a,b
    add a,2
    ld b,a
    jp pow_bub

.pow_call
    call _m32_powf
    pop bc                      ; drop y (discard only)
    pop bc
    pop bc                      ; drop x
    pop bc
    ret

ELSE

.cm32_sccz80_pow_callee
    pop hl                      ; return
    pop bc                      ; RHS
    pop de
    pop af                      ; LHS
    ex (sp),hl                  ; return to stack

    push de                     ; RHS
    push bc
    push hl                     ; LHS
    push af

    call _m32_powf
    pop af                      ; discard args only
    pop af
    pop af
    pop af
    ret

ENDIF
