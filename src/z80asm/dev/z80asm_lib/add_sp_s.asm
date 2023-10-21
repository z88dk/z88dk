; Substitute for the gbz80 and rabbit add sp, %s instruction
; uses self-modifying code

        SECTION code_l_sccz80
        PUBLIC  __z80asm__add_sp_s

__z80asm__add_sp_s:
        ld      (save_a+1), a           ; save a - cannot use stack
        ld      (save_hl+1), hl         ; save hl - cannot use stack
        ld      (save_de+1), de         ; save de - cannot use stack
        pop     hl                      ; return address
        ld      a, (hl+)                ; signed offset to add to stack
        ld      (return+1), hl          ; save return address

        ld      hl, 0
        add     hl, sp                  ; HL = SP

  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        bit     7, a
  ELSE
        ld      d, a
        and     0x80
        ld      a, d
  ENDIF
        ld      d, 0

        jr      z, positive
negative:
        neg
        ld      e, a                    ; A<0 => DE = -A
        and     a
        sbc     hl, de                  ; HL = new stack
        jr      continue

positive:
        ld      e, a                    ; A>=0 => DE = A
        add     hl, de                  ; HL = new stack

continue:
        ld      sp, hl

save_a: ld      a, 0                    ; retore registers and jump back to caller
save_hl:
        ld      hl, 0
save_de:
        ld      de, 0
return: jp      0
