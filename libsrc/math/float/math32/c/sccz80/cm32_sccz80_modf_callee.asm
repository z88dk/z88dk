
SECTION code_fp_math32

PUBLIC cm32_sccz80_modf_callee

EXTERN _m32_modff

; float modff(float x, float *y) callee
;
; sccz80 entry: SP = ret_outer, y(2), x(4)
; 8080/8085/gbz80 _m32_modff is sccz80: SP = ret, y(2), x(4)
; Z80 _m32_modff is SDCC:           SP = ret, x(4), y(2)
;
; Never pop af the return on 8080/8085/gbz80 (F bit 3 hardwired 0).

IF __CPU_GBZ80__

; Rotate ret_outer under y,x without ex (sp),hl (call helper).

.cm32_sccz80_modf_callee
    ld b,0
.modf_bub
    ld a,b
    cp 6
    jr Z,modf_call
    push bc
    ld hl,sp+2
    ld c,a
    ld b,0
    add hl,bc                   ; HL -> word[i]
    ld e,(hl+)
    ld d,(hl+)                  ; DE = word[i]
    ld c,(hl+)
    ld b,(hl)                   ; BC = word[i+1]
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
    jr modf_bub

.modf_call
    call _m32_modff
    add sp,6                    ; drop y,x (native)
    ret

ELIF __CPU_8085__

; Rotate ret_outer to the back: y, x, ret. Word loads via ld hl,(de).

.cm32_sccz80_modf_callee
    ld de,sp+0
    ld hl,(de)
    ld bc,hl                    ; BC = ret_outer
    ld de,sp+2
    ld hl,(de)
    ld de,sp+0
    ld (de),hl                  ; y
    ld de,sp+4
    ld hl,(de)
    ld de,sp+2
    ld (de),hl                  ; x LSW
    ld de,sp+6
    ld hl,(de)
    ld de,sp+4
    ld (de),hl                  ; x MSW
    ld hl,bc
    ld de,sp+6
    ld (de),hl                  ; ret_outer
    call _m32_modff
    pop bc                      ; drop y,x (discard only)
    pop bc
    pop bc
    ret

ELIF __CPU_INTEL__

; 8080: no ld hl,(de). Adjacent word swaps, ret in BC not AF.

.cm32_sccz80_modf_callee
    ld b,0
.modf_bub
    ld a,b
    cp 6
    jp Z,modf_call
    push bc
    ld de,sp+2                  ; frame after saved step
    ld hl,de
    ld e,a
    ld d,0
    add hl,de                   ; HL -> word[i]
    ld e,(hl+)
    ld d,(hl+)                  ; DE = word[i]
    push de
    ld e,(hl+)
    ld d,(hl)                   ; DE = word[i+1]
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
    jp modf_bub

.modf_call
    call _m32_modff
    pop bc
    pop bc
    pop bc
    ret

ELSE

; Z80: reverse to SDCC order (ret, x, y). pop af of ret is legal on Z80.

.cm32_sccz80_modf_callee
    pop af                      ; ret
    pop bc                      ; y
    pop hl                      ; x LSW
    pop de                      ; x MSW
    push af                     ; ret
    push bc                     ; y (deep)
    push de                     ; x MSW
    push hl                     ; x LSW
    call _m32_modff
    pop af                      ; drop x,y
    pop af
    pop af
    ret

ENDIF
