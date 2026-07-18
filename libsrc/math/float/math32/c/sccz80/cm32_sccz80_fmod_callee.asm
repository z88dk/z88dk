
SECTION code_fp_math32
PUBLIC cm32_sccz80_fmod_callee

EXTERN _m32_fmodf

; sccz80 callee → non-callee _m32_fmodf.
; Z80: _m32_fmodf is SDCC (master stack reverse).
; 8085: _m32_fmodf is sccz80; AF-safe left-rotate bridge (no pop af of ret).
; Synthetics: memory index/source only via HL or DE (never BC).
; Post-inc/dec forms: ld r,(hl+)/(hl-), ld (hl-),r etc.

IFDEF __CPU_INTEL__

; Same left-rotate callee bridge as pow.

.cm32_sccz80_fmod_callee
    ld b,0
.fmod_bub
    ld a,b
    cp 8
    jp Z,fmod_call
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
    jp fmod_bub

.fmod_call
    call _m32_fmodf
    pop bc                      ; drop args (discard only)
    pop bc
    pop bc
    pop bc
    ret

ELSE

.cm32_sccz80_fmod_callee
    ; Entry: stack = float left, float right, ret
    ; Reverse stack for SDCC non-callee _m32_fmodf
    pop hl                      ; ret
    pop af                      ; right
    pop bc
    pop de                      ; left
    ex (sp),hl                  ; ret
    push bc                     ; right
    push af
    push hl                     ; left
    push de
    call _m32_fmodf
    pop af                      ; discard args only
    pop af
    pop af
    pop af
    ret

ENDIF
