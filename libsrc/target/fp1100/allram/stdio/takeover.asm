; The Casio FP-1100's all-RAM console: the Z80's end of the sub-CPU program (../sub/sub.s.in).  The screen belongs to the sub-CPU, so the ROM's own
; program there is replaced at start-up (fp1100_sub_init, in code_crt_init) and from then on a byte goes to ours at a time by the polled handshake in
; fp1100_sub_send.  Needs the machine all RAM (-subtype=allram): nothing here uses the ROM.
;
; The takeover.  The sub-CPU runs the ROM's own program until this puts ours there; its first stage is the ROM's transport, which is the same hardware
; handshake the ROM's TRNC routines use: a byte is put on port $FFC0, port $FF80 gets $90 then $10 (the first raises INT2 of the sub-CPU, which takes the
; byte; bit 4 keeps the sub-CPU's answer, the INTS interrupt, unmasked) and the sub-CPU answers with INTS (vector $F0, so interrupt mode 2 with a table at
; $FFF0: the stack must be below that), the Z80 reading its status from port $FFC0 (0: taken).  Interrupts are off at all other times.  The first stage
; uses the ROM's "define character" command to put 40 bytes of loader into the video RAM and "run" to start it; the loader brings in the first page of
; the program through fp1100_sub_send, the rest follows through the program's own Pat command, and after that the ROM's part is out of the picture.

    MODULE  fp1100_allram_takeover
    SECTION code_clib

    PUBLIC  fp1100_sub_init
    PUBLIC  fp1100_sub_send
    PUBLIC  fp1100_sub_read
    PUBLIC  fp1100_sub_addr
    PUBLIC  fp1100_sub_glyph
    PUBLIC  fp1100_sub_cls
    PUBLIC  fp1100_sub_font
    EXTERN  generic_console_font32

    INCLUDE "../sub/sub.inc"

; A to the sub program: wait until it is ready (bit 7 of port $FF80 set), put the byte on port $FFC0, pulse INT2 ($FF80: $C0 then $20), wait for the
; acknowledgement (bit 7 clear).  Keeps BC, DE and HL.
fp1100_sub_send:
    push    bc
    push    de
    ld      bc, $FF80
fs1:
    in      e, (c)
    bit     7, e
    jr      z, fs1
    ld      c, $C0
    out     (c), a
    ld      c, $80
    ld      e, $C0
    out     (c), e
    ld      e, $20
    out     (c), e
fs2:
    in      e, (c)
    bit     7, e
    jr      nz, fs2
    pop     de
    pop     bc
    ret

; A = a byte from the sub program (7 bits), once it has been asked for something.  Keeps BC, DE and HL.
fp1100_sub_read:
    push    bc
    push    de
    ld      bc, $FF80
fr1:
    in      a, (c)
    bit     7, a
    jr      z, fr1
    and     $7F
    ld      e, $C0
    out     (c), e
    ld      e, $20
    out     (c), e
fr2:
    in      e, (c)
    bit     7, e
    jr      nz, fr2
    pop     de
    pop     bc
    ret

; DE = a VRAM address for the program.  Keeps BC, DE and HL.
fp1100_sub_addr:
    ld      a, SUB_ADDR
    call    fp1100_sub_send
    ld      a, e
    call    fp1100_sub_send
    ld      a, d
    jp      fp1100_sub_send

; Glyph slot A takes the 8 bytes at HL, bit reversed (the leftmost pixel is bit 0 there, and a font has it in bit 7).  HL ends 8 on.  Keeps BC and DE.
fp1100_sub_glyph:
    push    bc
    push    af
    ld      a, SUB_GLYPH
    call    fp1100_sub_send
    pop     af
    call    fp1100_sub_send
    ld      b, 8
fg1:
    ld      a, (hl)
    inc     hl
    call    reverse
    call    fp1100_sub_send
    djnz    fg1
    pop     bc
    ret

reverse:
    push    de
    ld      e, a
    ld      d, 8
    xor     a
fg2:
    rl      e
    rra
    dec     d
    jr      nz, fg2
    pop     de
    ret

; Clear the screen to the paper colour (bits 4 to 6 of __fp1100_attr).
    EXTERN  __fp1100_attr
    EXTERN  __fp1100_text
fp1100_sub_cls:
    ld      hl, __fp1100_text           ; (the text copy: spaces)
    ld      de, __fp1100_text + 1
    ld      bc, 40 * 25 - 1
    ld      (hl), 32
    ldir
    ld      de, $2000
    call    fp1100_sub_addr
    ld      a, (__fp1100_attr)
    rrca
    rrca
    rrca
    rrca
    and     7
    ld      c, a
    ld      b, 4                        ; 1000 cells: 3 of 256 and one of 232
fc1:
    ld      a, SUB_FILL
    call    fp1100_sub_send
    ld      a, b
    cp      1
    ld      a, 255
    jr      nz, fc2
    ld      a, 231
fc2:
    call    fp1100_sub_send
    ld      a, c
    call    fp1100_sub_send
    djnz    fc1
    ret

; A byte to the ROM's program: A = the byte.  Keeps all registers.
fb_put:
    push    bc
    push    af
    ld      bc, $FFC0
    out     (c), a
    ld      a, $AA
    ld      (fb_ack), a
    ld      c, $80
    ld      a, $90
    out     (c), a
    ld      a, $10
    out     (c), a
    ei
fb_w:
    ld      a, (fb_ack)
    cp      $AA
    jr      z, fb_w
    di
    ld      a, $10
    out     (c), a
    pop     af
    pop     bc
    ret

fb_isr:
    push    af
    push    bc
    ld      bc, $FFC0
    in      a, (c)
    ld      (fb_ack), a
    pop     bc
    pop     af
    ei
    reti

fb_ack:
    defb    0

; Glyphs 32 to 127 from generic_console_font32 (8 bytes each: 0 if there is none) into the sub program.
fp1100_sub_font:
    ld      hl, (generic_console_font32)
    ld      a, h
    or      l
    ret     z
    ld      c, 32
fb_gl:
    ld      a, c
    call    fp1100_sub_glyph
    inc     c
    bit     7, c
    jr      z, fb_gl
    ret

; The takeover, the font (glyphs 32 to 127 from generic_console_font32) and a clear screen.  Interrupts end up off.
fp1100_sub_init:
    push    ix
    di
    ld      a, $FF
    ld      i, a
    im      2
    ld      hl, fb_isr
    ld      ($FFF0), hl
    ld      a, $21                      ; screen size: 40 columns
    call    fb_put
    xor     a
    call    fb_put
    ld      a, $0D                      ; clear it
    call    fb_put
    ld      a, $12                      ; the cursor to column 4, row 21: where the loader goes
    call    fb_put
    ld      a, 4
    call    fb_put
    ld      a, 21
    call    fb_put
    ld      hl, sub_loader
    ld      e, 5
fb_ld:
    ld      a, $20                      ; "define character": 8 bytes into the cell at the cursor, which moves on
    call    fb_put
    ld      b, 8
fb_l8:
    ld      a, (hl)
    inc     hl
    call    fb_put
    djnz    fb_l8
    dec     e
    jr      nz, fb_ld
    ld      a, $6B                      ; run it
    call    fb_put
    ld      hl, sub_page1               ; the loader takes the first page, which is run from the video RAM (inverted: the bus inverts a read)
    ld      de, SUB_SIZE
fb_sp:
    ld      a, (hl)
    cpl
    inc     hl
    call    fp1100_sub_send
    dec     de
    ld      a, d
    or      e
    jr      nz, fb_sp
    ld      a, SUB_ADDR                 ; the rest: into the video RAM at $9100, from the command that takes 8 bytes a time
    call    fp1100_sub_send
    xor     a
    call    fp1100_sub_send
    ld      a, $91
    call    fp1100_sub_send
    ld      hl, sub_page2
    ld      c, SUB2_SIZE / 8
fb_p2:
    ld      a, SUB_PAT
    call    fp1100_sub_send
    ld      b, 8
fb_p3:
    ld      a, (hl)
    cpl
    inc     hl
    call    fp1100_sub_send
    djnz    fb_p3
    dec     c
    jr      nz, fb_p2
    call    fp1100_sub_font
    call    fp1100_sub_cls
    pop     ix
    ret

sub_loader:
    BINARY  "../sub/loader.bin"
sub_page1:
    BINARY  "../sub/sub.bin"
sub_page2:
    BINARY  "../sub/sub2.bin"

    SECTION code_crt_init
    call    fp1100_sub_init
