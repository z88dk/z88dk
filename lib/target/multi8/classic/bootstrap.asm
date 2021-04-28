; Bootstrap for loading allram multi8 tapes

    SECTION    BOOTSTRAP

    PUBLIC    __multi8_bootstrap_built

    defc    __multi8_bootstrap_built = 1

    org    $c000

    ld      hl,intro_string
    call    print_string
    call    setup_memory_map
    call    asm_tape_load
    jp      nc,$0000
    ld      hl,failed_string
    call    reset_memory_map
    call    print_string
loop:
    jp      loop


intro_string:
    defm    "z88dk Multi8 bootstrap starting\n"
    defb    0
failed_string:
    defm    "Loading failed\n"
    defb    0


setup_memory_map:
    ; Here we need to switch to 64k RAM mode
    ; We have no access to the display (unless we page it in)
    di
    ld      a,@00100000     ;bit 5 set = RAM
                            ;bit 4 reset = RAM
    out     ($2a),a
    ret

reset_memory_map:
    ; Here we need to switch to 64k RAM mode
    ; We have no access to the display (unless we page it in)
    ld      a,@00010000     ;bit 5 set = RAM
                            ;bit 4 reset = RAM
    out     ($2a),a
    ei
    ret

; Write string: hl = string
print_string:
    ld      a,(hl)
    and     a
    ret     z
    push    hl
    rst     $18
    pop     hl
    inc     hl
    jr      print_string


;
; Load a block to the address specified in the file header
;
; Exit: nc = success
;        c = failure
;
asm_tape_load:
    call    initialise_hw
    ld      a,$4e
    out     ($21),a
    ld      a,$14
    out     ($21),a
    in      a,($20)
wait_for_ready:
    in      a,($21)
    bit     1,a
    jr      z,wait_for_ready
    in      a,($21)
    and     $30
    jr      nz,asm_tape_load
    in      a,($20)            ;ac4
    cp      $3a
    jr      nz,asm_tape_load
    call    read_byte
    ld      c,a
    ld      h,a
    call    read_byte
    ld      l,a
    add     c
    ld      c,a
    call    read_byte
    add     c
    jr      nz,failure        ;@0b07
next_block:
    call    read_byte
    cp      $3a
    jr      nz,failure
    call    read_byte
    ld      c,a
    ld      b,a
    or      a
    ret     z            ;end of file
read_block_loop:
    call    read_byte
IF VERIFY
    push    af
    ld      a,(some_var)        ;some_var = f97b
    or      a
    jr      z,skip_verify
    pop     af
    cp      (hl)
    jr      nz,failure
    jr      rejoin
skip_verify:
    pop     af
ENDIF
    ld      (hl),a
rejoin:
    add     c
    ld      c,a
    inc     hl
    dec     b
    jr      nz,read_block_loop
    call    read_byte
    add     c
    jr      z,next_block
failure:
    scf
    ret
failure_pop:
    pop     af    ;return address from read_byte
    jr      failure

read_byte:
    in      a,($21)
    bit     1,a
    jr      z,read_byte
    in      a,($21)
    and     $30
    jr      nz,failure_pop
    in      a,($20)
    ret


initialise_hw:
    ld      a,$ce
    out     ($21),a
    ld      a,$27
    out     ($21),a
    ld      a,$77
    out     ($21),a
    ret

