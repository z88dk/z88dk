; Substitute for the gbz80 and rabbit add sp, %s instruction
; uses self-modifying code

        SECTION code_l_sccz80
        PUBLIC  __z80asm__add_sp_s

__z80asm__add_sp_s:
        ld      (save_a+1), a           ; save a - cannot use stack
        ld      (save_hl+1), hl         ; save hl - cannot use stack
        pop     hl                      ; return address
        ld      a, (hl+)                ; signed offset to add to stack
        ld      (return+1), hl          ; save return address

        ld      l, a
        rla
        sbc     a, a
        ld      h, a                    ; hl = sign extended A
        add     hl, sp
        ld      sp, hl                  ; add to sp

save_a: ld      a, 0                    ; retore registers and jump back to caller
save_hl:
        ld      hl, 0
return: jp      0
