    SECTION code_clib

    PUBLIC  adcvrt
    PUBLIC  _adcvrt

    PUBLIC subcpu_7508
    PUBLIC _subcpu_7508

adcvrt:
_adcvrt:
    ; BIOS ADCVRT call, Analog to digital conversion
    ex      de,hl
    ld      hl,(1)          ; Use WBOOT address to find the first entry in the BIOS jp table
    ld      a,$6f           ; ADCVRT offset
    add     l
    ld      l,a
    ld      c,e             ; Channel ID
    ld      de,retaddr
    push    de
    jp      (hl)
.retaddr
    ld      l,a             ; Return status from ADCVRT call
    ld      h,0
    ld      de,0
    ret


maski:
_maski:
    ; Calls PX-8 BIOS MASKI function
    ; b: 1 = Enable; 0 = Disable
    ; c: Interrupts bitmask
    ;   bit 0: 7508
    ;   bit 1: 8251
    ;   bit 2: DCD
    ;   bit 3: ICF
    ;   bit 4: OVF
    ;   bit 5: EXT
    ld      hl,(1)          ; Use WBOOT address to find the first entry in the BIOS jp table
    ld      a,$57           ; MASKI offset
    add     l
    ld      l,a
    jp      (hl)


write_byte:
    ; Writes byte to 7508 subcpu
    ; c = byte to write
    in      a,(5)           ; Check whether 7508 is accessible
    and     8               ; Bit 3 = control signal
    jz      write_byte
    ld      a,c
    out     (6),a
    jp      reset_signal


read_byte:
    ; Reads byte from 7508 subcpu.
    ; Caller should call reset_signal after every read_byte except last one
    ; return a = read byte
    in      a,(5)           ; Check whether 7508 is accessible
    and     8               ; Bit 3 = control signal
    jz      read_byte
    in      a,(6)
    ret


reset_signal:
    ; Resets 7508 control signal
    ld      a,2             ; Reset control signal
    out     (1),a
    ret


subcpu_7508:
_subcpu_7508:
    ; Performs 7508 subcpu command
    ; subcpu_7508(char cmd, char out_sz, void* out_buf, char in_sz, void* in_buf) __z88dk_sdccdecl
    ld      b,0             ; Disable interrupts from 7508
    ld      c,1
    call    maski
    ld      hl,2
    add     hl,sp
    ld      c,(hl)          ; Command
    call    write_byte
    inc     hl
    ld      a,(hl)          ; a = out_sz
    cp      0
    jz      skip_write
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)         ; de = out_buf address
.next_write
    push    af
    ld      a,(de)
    ld      c,a
    call    write_byte
    inc     de
    pop     af
    dec     a
    cp      0
    jnz     next_write
    jr      read_data
.skip_write
    inc     hl
    inc     hl              ; skip out_buf
.read_data
    inc     hl
    ld      a,(hl)          ; a = in_sz
    cp      0
    jz      done
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)          ; de = in_buf address
.next_read
    push    af
    call    read_byte
    ld      (de),a
    inc     de
    pop     af
    dec     a
    cp      0
    jz      done
    ld      b,a
    call    reset_signal
    ld      a,b
    jp      next_read
.done
    ld      b,1             ; Enable interrupts from 7508
    ld      c,1
    call    maski
    ret
