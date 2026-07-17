;
; Loop 24x8 for ticks comparison (8085)
SECTION code_user
PUBLIC mulu_32_24x8_loop

.mulu_32_24x8_loop
    ; A * CDE -> BCDE
    or a
    jr NZ,nlz
    ld b,a
    ld c,a
    ld d,a
    ld e,a
    ret
.nlz
    push de
    push bc
    ld b,8
    ld hl,0
    ld d,h
    ld e,l                      ; DEHL product 0 as 32? use B=0,A=0,HL=0 -> product BAHL
    ld e,a                      ; E = mult
    pop bc                      ; C = msb
    pop hl                      ; wait messed

    ; restart clean: product in BCDE, mult in A saved in stack
    ld b,0
    push bc                     ; high 0
    ld bc,0
    push bc                     ; product 32 on stack as 0
    ; use registers: result = 0; for i=0..7: result<<=1; if mult bit: result+=mcand; mult<<=1
    ; mcand CDE, mult A
    ld b,8
.loop
    push bc
    ; product in stack? keep product in IX-less: use alt stack frame
    pop bc
    djnz loop                   ; djnz not on 8085
