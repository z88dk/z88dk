
SECTION code_fp_math32
PUBLIC cm32_sccz80_pow_callee

EXTERN _m32_powf

; sccz80 callee → non-callee _m32_powf.
; Z80: _m32_powf is SDCC (master stack reverse).
; 8085: _m32_powf is sccz80; AF-safe left-rotate bridge (no pop af of ret).
; Synthetics: memory index/source only via HL or DE (never BC).
; Post-inc/dec forms: ld r,(hl+)/(hl-), ld (hl-),r etc.

IF __CPU_GBZ80__

; sccz80 entry: SP = ret_outer, y(4), x(4)
; Bubble ret under the args without ex (sp),hl (148c helper).

.cm32_sccz80_pow_callee
    ld b,0
.pow_bub
    ld a,b
    cp 8
    jr Z,pow_call
    push bc                     ; save step
    ld hl,sp+2
    ld c,a
    ld b,0
    add hl,bc                   ; HL -> word[i]
    ld e,(hl+)
    ld d,(hl+)                  ; DE = word[i]
    ld c,(hl+)
    ld b,(hl)                   ; BC = word[i+1]; HL at hi
    ld (hl),d
    dec hl
    ld (hl),e                   ; word[i+1] <- old word[i]
    dec hl
    ld (hl),b
    dec hl
    ld (hl),c                   ; word[i] <- old word[i+1]
    pop bc
    ld a,b
    add a,2
    ld b,a
    jr pow_bub

.pow_call
    call _m32_powf
    add sp,8                    ; drop y,x
    ret

ELIF __CPU_8085__

; sccz80 entry: SP = ret_outer, y0, y1, x0, x1
; Rotate ret_outer to the back with ld hl,(de)/ld (de),hl, then
; non-callee _m32_powf sees ret, y, x.  No pop af of a float.

.cm32_sccz80_pow_callee
    ld de,sp+0
    ld hl,(de)
    ld bc,hl                    ; BC = ret_outer
    ld de,sp+2
    ld hl,(de)
    ld de,sp+0
    ld (de),hl                  ; y0
    ld de,sp+4
    ld hl,(de)
    ld de,sp+2
    ld (de),hl                  ; y1
    ld de,sp+6
    ld hl,(de)
    ld de,sp+4
    ld (de),hl                  ; x0
    ld de,sp+8
    ld hl,(de)
    ld de,sp+6
    ld (de),hl                  ; x1
    ld hl,bc
    ld de,sp+8
    ld (de),hl                  ; ret_outer
    call _m32_powf
    pop bc                      ; drop y,x (discard only)
    pop bc
    pop bc
    pop bc
    ret

ELIF __CPU_INTEL__

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
