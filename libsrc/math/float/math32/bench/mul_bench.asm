
; Microbench: 8085 24x8 multiply strategies for z88dk-ticks -m8085
; org 0; measure from START to END

    org 0
    jp begin

;--- unrolled (copy of production core) ---
    include "../asm/8085/f32_8085_mulu_32h_24x24.asm"

;--- loop 24x8 ---
SECTION code_user
PUBLIC mulu_32_24x8_loop

.mulu_32_24x8_loop
    ; A * CDE -> BCDE , 8-step left-to-right
    or a
    jr NZ,lp_nz
    ld b,a
    ld c,a
    ld d,a
    ld e,a
    ret
.lp_nz
    ld b,a                      ; mult
    ld a,c
    ld h,d
    ld l,e                      ; AHL = mcand
    ld c,a                      ; C = mcand msb (restore)
    ; actually C was mcand msb; AHL is copy; DE is low - same as unrolled setup
    ld a,c
    ld h,d
    ld l,e
    ld b,8
    ld de,0
    push de
    pop de                      ; clear? use product BAHL start 0
    xor a
    ld h,a
    ld l,a                      ; product 0 in AHL, mult in stacked B from earlier
    ; reload mult to B - we set b=8 as count. Save mult in memory
    ; redo with mult in memory at multb
    jp loop_entry

.multb
    defb 0
.mcand
    defb 0,0,0                  ; C,D,E

.loop_entry
    ; entry A=mult, CDE=mcand
    ld (multb),a
    ld a,c
    ld (mcand),a
    ld a,d
    ld (mcand+1),a
    ld a,e
    ld (mcand+2),a
    xor a
    ld h,a
    ld l,a                      ; product low
    ld b,a                      ; product high B|A|H|L with A=0
    ld c,8
.lp
    ; dbl product BAHL where product is B|A|H|L - use only AHL + B as top
    add hl,hl
    rla
    push af
    ld a,b
    rla
    ld b,a
    pop af
    ; shift mult left
    push af
    ld a,(multb)
    add a,a
    ld (multb),a
    pop af
    jp NC,lp_next
    ; add mcand
    push de
    ld a,(mcand+2)
    ld e,a
    ld a,(mcand+1)
    ld d,a
    ld a,(mcand)
    ld c,a
    pop af                      ; wrong
    ; simplify: keep mcand in DE and C always
.lp_next
    dec c
    jp NZ,lp
    ld c,a
    ex de,hl
    ret
