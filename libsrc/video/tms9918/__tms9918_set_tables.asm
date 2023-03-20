


;Reg/Bit    7      6    5    4    3    2    1    0
;0          -      -    -    -    -    -    M2   EXTVID
;1          4/16K  BL   GINT M1   M3   -    SI   MAG
;2          -      -    -    -    PN13 PN12 PN11 PN10   * $400
;3          CT13   CT12 CT11 CT10 CT9  CT8  CT7  CT6    * $40
;4          -      -    -    -	  -    PG13 PG12 PG11   * $800
;5          -      SA13 SA12 SA11 SA10 SA9  SA8  SA7    * $80
;6          -      -    -    -    -    SG13 SG12 SG11   * $800

SECTION code_clib
PUBLIC  __tms9918_set_tables


EXTERN __tms9918_colour_table
EXTERN __tms9918_pattern_generator
EXTERN __tms9918_pattern_name
EXTERN __tms9918_sprite_attribute
EXTERN __tms9918_sprite_generator

EXTERN  VDPreg_Write


__tms9918_set_tables:
    ;hl = address table
    ; Consider from register 2 onwards
    ld      e,2
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_pattern_name),bc
    ld      a,b
    srl     a
    srl     a
    call    VDPreg_Write        ;Register 2 - pattern name
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_colour_table),bc
    ld      a,(hl)              ;r3 value
    inc     hl
    call    VDPreg_Write        ;Register 3 - colour table
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_pattern_generator),bc
    ld      a,(hl)              ;r4 value
    inc     hl
    call    VDPreg_Write        ;Register 4 - pattern generator
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_sprite_attribute),bc
    ld      a,b
    rl      c
    rla
    and     @01111111
    call    VDPreg_Write        ;Register 5 - sprite attribute
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    inc     hl
    ld      (__tms9918_sprite_generator),bc
    ld      a,b
    srl     a
    srl     a
    srl     a
    and     @00000111
    call    VDPreg_Write        ;Register 5 - sprite generator

    ;; And any extra registers afterwards
reg_loop:
    ld      a,(hl)
    cp      255
    ret     z
    ld      e,a
    inc     hl
    ld      a,(hl)
    inc     hl
    call    VDPreg_Write
    jr      reg_loop
    ret
