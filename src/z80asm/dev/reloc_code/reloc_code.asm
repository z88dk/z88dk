;------------------------------------------------------------------------------
; reloc routine included with the -R option from the original z80asm
; disassembled by Paulo Custodio
;------------------------------------------------------------------------------

reloc:  ex      af, af'                 ; swap to the alternate registers
        exx                             ; TODO: needs changing in platforms that reserve AF'
							; as the zx81

        push    iy                      ; IY is the load address
        pop     hl                      ; move to HL
							; TODO: allow command line to select register
							; depending on the platform
        ld      bc, end_reloc-reloc
        add     hl, bc                  ; add size of routine

        ld      e, (hl)                 ; load number of relocatable addresses to DE
        inc     hl
        ld      d, (hl)
        push    de                      ; save number of relocatable addresses
        inc     hl

        ld      c, (hl)                 ; size in bytes of reloc table to BC
        inc     hl
        ld      b, (hl)
        inc     hl

        push    hl                      ; save address of first reloc element

        add     hl, bc                  ; point to end of reloc routine + reloc addresses
							; i.e. start of payload code
        ld      b, h                    ; start of code to BC
        ld      c, l

next_entry:
        ex      (sp), hl                ; HL=pointer to reloc table, (SP)=pointer to code

        ld      a, (hl)                 ; get first byte, if zero offset is two bytes
        inc     hl

        or      a                       ; is offset zero?
        jr      nz, offset_8bit
offset_16bit:
        ld      e, (hl)                 ; load offset to DE
        inc     hl
        ld      d, (hl)
        inc     hl                      ; HL points to next entry in table
        jr      add_offset


offset_8bit:
        ld      d, $00                  ; load 8-bit offset to DE
        ld      e, a

add_offset:
        ex      (sp), hl                ; HL=pointer to code, (SP)=pointer to reloc table
        add     hl, de                  ; HL point to next address to recompute

        ld      e, (hl)                 ; DE = address than needs relocation
        inc     hl
        ld      d, (hl)                 ; HL = pointer to high byte

        ex      de, hl                  ; address that needs relocation to DE
        add     hl, bc                  ; add to start of code
        ex      de, hl                  ; back to HL

        ld      (hl), d                 ; store relocated address in code
        dec     hl
        ld      (hl), e

        pop     de                      ; DE=pointer to reloc table

        ex      (sp), hl                ; (SP)=pointer to code, HL=number of entries
        dec     hl                      ; one less

        ld      a, h                    ; check if reached end of tabke
        or      l
        ex      (sp), hl                ; restore (SP)=number of entries, HL=pointer to code
        push    de                      ; restore (SP)=pointer to reloc table

        jr      nz, next_entry          ; jump if number of entries not zero

        pop     af                      ; cleanup stack
        pop     af

        ld      (iy), $C3               ; replace start of reloc routine with
							; jump to start of code
        ld      (iy+$01), c
        ld      (iy+$02), b

        exx                             ; restore normal registers
        ex      af, af'
        jp      (iy)                    ; start the code
end_reloc:
