;
;	Samsung SPC-1500: the cassette, without the IPL ROM, in the machine's
;	own format (the one the IPL's "C: cassette system" loads: a header block
;	and then data)
;
;	int spc1500_tape_save(const char *name, const void *addr, size_t len,
;	const void *user, size_t ulen) __smallc;
;	int spc1500_tape_load_to(const char *name, void *buf, size_t len, void
;	*user, size_t ulen) __smallc;
;
;	A file is two blocks: a header (128 bytes: type 1, the name from byte 1
;	(14 characters, NUL padded), the length of the data at $12 and, from
;	$20, up to 96 bytes
;	of the program's own: user and ulen) and the data.  save returns 0, or
;	-1 if the player stopped it.  load_to passes over the files with other
;	names, puts the
;	header's user bytes at user (ulen of them) and reads the data into buf
;	(up to len): it returns the bytes read (len if the file is whole: less
;	if the player stopped it
;	or a checksum failed) or -1 if no header was read.  The deck is the
;	player's: press PLAY (and RECORD to save); the routines turn the motor
;	on through the AY's
;	port B (a pulse on bit 7 flips the relay) when the deck is running and
;	wait for it, and turn it off at the end.  Shift and Break together stop
;	a tape operation.
;	Interrupts are off while they work.
;
;	The format (a block is read once; the IPL writes and reads one copy): a
;	leader (22000 zero bits, 40 ones, 40 zeros and a one for a header block,
;	11000, 20, 20 and
;	a one for a data block), each byte a one bit and its 8 bits, most
;	significant first, then the count of the one bits of the data as two
;	bytes (high, low) and a one bit.
;	A bit is a low then a high level on the cassette output (the 8255's port
;	C bit 0 set then cleared, through the bit set/reset port $1A03): a zero
;	840 and 770 T-states
;	(plus the loop), a one 1680 and 1610.  A bit is read at the rising edge
;	of the input (port B bit 1, $1A01): 315 us later it is a one if the
;	input is still high.
;
;	Low level (the blocks): asm_tape_tx_block, asm_tape_rx_block (hl = the
;	data, bc = its length, e = $CC for a header block, $53 for a data block;
;	carry if stopped or a bad
;	checksum, and for rx the bytes read in tp_got).
;

    SECTION code_clib
    PUBLIC  spc1500_tape_save
    PUBLIC  _spc1500_tape_save
    PUBLIC  spc1500_tape_load_to
    PUBLIC  _spc1500_tape_load_to
    PUBLIC  asm_tape_tx_block
    PUBLIC  asm_tape_rx_block
    PUBLIC  asm_tape_deck_on
    PUBLIC  asm_tape_deck_off
    EXTERN  l_push_di
    EXTERN  l_pop_ei

    defc    TAPE_HEADER = $cc
    defc    TAPE_DATA = $53

; --- the deck

; Flip the deck's relay: the AY's register 15 (port B) gets a low pulse on
; bit 7 (the other bits as the IPL leaves them: $BF, which has the IPL ROM
; selected).  The chip ignores writes to the port while the mixer
; (register 7) has it as an input (bit 7 clear), which sound code can leave
; so: it is made an output first.  Uses a, bc.
deck_pulse:
    ld      bc, $1c00
    ld      a, 7
    out     (c), a
    ld      b, $1b
    in      a, (c)
    or      $80
    out     (c), a
    ld      b, $1c
    ld      a, 15
    out     (c), a
    ld      b, $1b
    ld      a, $3f
    out     (c), a
    ld      a, $bf
    out     (c), a
    ret

; Wait for the deck to run: port B bit 0 reads 0 when the tape runs and the
; relay is on.  Pulse the relay until it does (with 20 ms between each, so that
; the player pressing PLAY is
; caught).  Carry if Shift and Break stop it.  Uses af, bc, de.
asm_tape_deck_on:
deck_wait:
    ld      bc, $1a01
    in      a, (c)
    and     1
    ret     z
    call    deck_pulse
    ld      de, 1500
deck_delay:
    ld      bc, $1900
    in      a, (c)                      ; Shift and Break
    and     $12
    cp      $12
    jr      z, deck_stopped
    ld      b, 4
deck_spin:
    dec     b
    jr      nz, deck_spin
    dec     de
    ld      a, d
    or      e
    jr      nz, deck_delay
    jr      deck_wait
deck_stopped:
    scf
    ret

; The motor off: the relay flipped while the tape is running (a few tries), and
; port C bit 3 reset as the IPL does.  Preserves the carry.  Uses a, bc, d.
asm_tape_deck_off:
    push    af
    ld      bc, $1a03
    ld      a, 6
    out     (c), a
    ld      d, 10
deck_off1:
    ld      bc, $1a01
    in      a, (c)
    and     1
    jr      nz, deck_off2               ; stopped already
    call    deck_pulse
    dec     d
    jr      nz, deck_off1
deck_off2:
    pop     af
    ret

; --- writing: BC is $1A03 (the bit set/reset port) throughout; a bit's two
; levels are timed by the loops

; a one
tx_one:
    ld      a, 1
    out     (c), a                      ; the output low
    ld      l, 120
tx_one_low:
    dec     l
    jp      nz, tx_one_low
    xor     a
    out     (c), a                      ; high
    ld      l, 115
tx_one_high:
    dec     l
    jp      nz, tx_one_high
    ret

; a zero
tx_zero:
    ld      a, 1
    out     (c), a
    ld      l, 60
tx_zero_low:
    dec     l
    jp      nz, tx_zero_low
    xor     a
    out     (c), a
    ld      l, 55
tx_zero_high:
    dec     l
    jp      nz, tx_zero_high
    ret

; e = the byte: a one for the start and then the 8 bits, most significant first.
; Uses a, d, l
tx_byte:
    call    tx_one
    ld      d, 8
tx_byte_bit:
    rlc     e
    jr      nc, tx_byte_zero
    call    tx_one
    jr      tx_byte_next
tx_byte_zero:
    call    tx_zero
tx_byte_next:
    dec     d
    jr      nz, tx_byte_bit
    ret

; hl = the data, bc = its length, e = the mark.  Carry if stopped.
asm_tape_tx_block:
    ld      (tp_ptr), hl
    ld      (tp_len), bc
    ld      a, e
    ld      (tp_mark), a
    ld      de, 0                       ; the count of one bits
    ld      a, b
    or      c
    jr      z, tx_sum_done
tx_sum_byte:
    ld      a, (hl)
    inc     hl
tx_sum_bits:
    or      a
    jr      z, tx_sum_next
    srl     a
    jr      nc, tx_sum_bits
    inc     de
    jr      tx_sum_bits
tx_sum_next:
    dec     bc
    ld      a, b
    or      c
    jr      nz, tx_sum_byte
tx_sum_done:
    ld      (tp_sum), de
    call    asm_tape_deck_on
    jp      c, tx_stopped
    ld      de, 22000                   ; the leader: zeros, ones, zeros, a one
    ld      b, 40
    ld      a, (tp_mark)
    cp      TAPE_HEADER
    jr      z, tx_leader
    ld      de, 11000
    ld      b, 20
tx_leader:
    ld      a, b
    ld      (tp_n), a
    ld      bc, $1a03
tx_leader_zeros:
    call    tx_zero
    dec     de
    ld      a, d
    or      e
    jr      nz, tx_leader_zeros
    ld      a, (tp_n)
    ld      e, a
tx_leader_ones:
    call    tx_one
    dec     e
    jr      nz, tx_leader_ones
    ld      a, (tp_n)
    ld      e, a
tx_leader_zeros2:
    call    tx_zero
    dec     e
    jr      nz, tx_leader_zeros2
    call    tx_one
tx_data:
    ld      hl, (tp_len)
    ld      a, h
    or      l
    jr      z, tx_checksum
    ld      bc, $1900                   ; Shift and Break together stop it (checked for each byte, as the ROM does)
    in      a, (c)
    and     $12
    cp      $12
    jr      z, tx_stopped
    ld      bc, $1a03
    ld      hl, (tp_ptr)
    ld      e, (hl)
    inc     hl
    ld      (tp_ptr), hl
    ld      hl, (tp_len)
    dec     hl
    ld      (tp_len), hl
    call    tx_byte
    jr      tx_data
tx_checksum:
    ld      hl, (tp_sum)
    ld      e, h
    call    tx_byte
    ld      hl, (tp_sum)
    ld      e, l
    call    tx_byte
    call    tx_one                      ; the end bit
    and     a
    jr      tx_end
tx_stopped:
    scf
tx_end:
    jp      asm_tape_deck_off

; --- reading: BC is $1A01 (port B: bit 1 the input) throughout

; Shift and Break together: Z if both are down.  Uses a (and bc, restored)
rx_stop:
    ld      bc, $1900
    in      a, (c)
    ld      bc, $1a01
    and     $12
    cp      $12
    ret

; Wait for the input to go low and then high: a rising edge.  Carry if stopped.
; Uses a
rx_edge:
rx_edge_low:
    in      a, (c)
    and     2
    jr      z, rx_edge_high
    call    rx_stop
    jr      z, rx_edge_stopped
    jr      rx_edge_low
rx_edge_high:
    in      a, (c)
    and     2
    jr      nz, rx_edge_done
    call    rx_stop
    jr      z, rx_edge_stopped
    jr      rx_edge_high
rx_edge_done:
    and     a
    ret
rx_edge_stopped:
    scf
    ret

; A bit: at the edge, 315 us later (the loop is 90 times 14 T-states) it is a
; one if the input is high.  a = 0 or 1; carry if stopped.  Uses a, l
rx_bit:
    call    rx_edge
    ret     c
    ld      l, 90
rx_bit_wait:
    dec     l
    jp      nz, rx_bit_wait
    in      a, (c)
    and     2
    rrca
    ret                                 ; (the carry: bit 0 of 2 or 0, clear)

; e = the byte read: 8 bits, most significant first, counting the ones in
; tp_ones, and then the edge of the next start bit.  Carry if stopped.  Uses a,
; d, hl
rx_byte:
    ld      d, 8
rx_byte_bit:
    call    rx_bit
    ret     c
    rra                                 ; the bit to the carry
    jr      nc, rx_byte_zero
    ld      hl, (tp_ones)
    inc     hl
    ld      (tp_ones), hl
    scf
rx_byte_zero:
    ld      a, e
    rla
    ld      e, a
    dec     d
    jr      nz, rx_byte_bit
    jp      rx_edge

; hl = where the data goes, bc = its length, e = the mark.  Carry if stopped or
; the checksum is wrong; the bytes read are in tp_got.
asm_tape_rx_block:
    ld      (tp_ptr), hl
    ld      (tp_len), bc
    ld      a, e
    ld      (tp_mark), a
    ld      hl, 0
    ld      (tp_got), hl
    ld      (tp_ones), hl
    call    asm_tape_deck_on
    jp      c, rx_fail
    ld      a, (tp_mark)
    cp      TAPE_HEADER
    ld      a, 40
    jr      z, rx_n
    ld      a, 20
rx_n:
    ld      (tp_n), a
    ld      bc, $1a01
rx_leader:
    ld      a, (tp_n)
    ld      e, a                        ; the ones to see (a zero starts again)
rx_ones:
    call    rx_bit
    jr      c, rx_fail
    or      a
    jr      z, rx_leader
    dec     e
    jr      nz, rx_ones
    ld      a, (tp_n)
    ld      e, a                        ; then the zeros (a one starts again)
rx_zeros:
    call    rx_bit
    jr      c, rx_fail
    or      a
    jr      nz, rx_leader
    dec     e
    jr      nz, rx_zeros
    call    rx_edge                     ; the leader's last one: its edge
    jr      c, rx_fail
rx_start:
    call    rx_bit                      ; the first byte's start bit: bits until a one
    jr      c, rx_fail
    or      a
    jr      z, rx_start
    ld      hl, 0
    ld      (tp_ones), hl
rx_data:
    ld      hl, (tp_len)
    ld      a, h
    or      l
    jr      z, rx_sum
    call    rx_byte
    jr      c, rx_fail
    ld      hl, (tp_ptr)
    ld      (hl), e
    inc     hl
    ld      (tp_ptr), hl
    ld      hl, (tp_got)
    inc     hl
    ld      (tp_got), hl
    ld      hl, (tp_len)
    dec     hl
    ld      (tp_len), hl
    jr      rx_data
rx_sum:
    ld      hl, (tp_ones)
    ld      (tp_sum), hl                ; the count before the checksum's own bits
    call    rx_byte
    jr      c, rx_fail
    ld      a, e
    ld      (tp_check + 1), a
    call    rx_byte
    jr      c, rx_fail
    ld      a, e
    ld      (tp_check), a
    ld      hl, (tp_sum)
    ld      de, (tp_check)
    or      a
    sbc     hl, de
    jr      nz, rx_fail
    and     a
    jp      asm_tape_deck_off
rx_fail:
    scf
    jp      asm_tape_deck_off

; --- the files

; int spc1500_tape_save(const char *name, const void *addr, size_t len, const
; void *user, size_t ulen) __smallc
spc1500_tape_save:
_spc1500_tape_save:
    call    l_push_di                   ; (the interrupt state is kept on the stack: a word more)
    push    ix
    ld      ix, 6
    add     ix, sp                      ; (ix + 0: ulen, 2: user, 4: len, 6: addr, 8: name)
    call    fcb_clear
    ld      l, (ix + 8)
    ld      h, (ix + 9)                 ; the name
    ld      de, tp_fcb + 1
    ld      b, 14
save_name:
    ld      a, (hl)
    or      a
    jr      z, save_name_done
    ld      (de), a
    inc     hl
    inc     de
    djnz    save_name
save_name_done:
    ld      a, (ix + 4)
    ld      (tp_fcb + $12), a
    ld      a, (ix + 5)
    ld      (tp_fcb + $13), a
    ld      c, (ix + 0)
    ld      b, (ix + 1)                 ; the user bytes
    ld      a, b
    or      a
    jr      nz, save_user_big
    ld      a, c
    cp      97
    jr      c, save_user_ok
save_user_big:
    ld      bc, 96
save_user_ok:
    ld      a, b
    or      c
    jr      z, save_header
    ld      l, (ix + 2)
    ld      h, (ix + 3)
    ld      de, tp_fcb + $20
    ldir
save_header:
    ld      hl, tp_fcb
    ld      bc, 128
    ld      e, TAPE_HEADER
    call    asm_tape_tx_block
    jr      c, save_fail
    ld      l, (ix + 6)
    ld      h, (ix + 7)
    ld      c, (ix + 4)
    ld      b, (ix + 5)
    ld      e, TAPE_DATA
    call    asm_tape_tx_block
    jr      c, save_fail
    ld      hl, 0
    jr      save_done
save_fail:
    ld      hl, -1
save_done:
    pop     ix
    call    l_pop_ei
    ret

; int spc1500_tape_load_to(const char *name, void *buf, size_t len, void *user,
; size_t ulen) __smallc
spc1500_tape_load_to:
_spc1500_tape_load_to:
    call    l_push_di
    push    ix
    ld      ix, 6
    add     ix, sp
load_header:
    ld      hl, tp_fcb
    ld      bc, 128
    ld      e, TAPE_HEADER
    call    asm_tape_rx_block
    jr      c, load_none                ; (stopped, or a header that fails its checksum is passed over by the leader wait: a failed block ends it)
    ld      l, (ix + 8)
    ld      h, (ix + 9)                 ; the name
    ld      de, tp_fcb + 1
    ld      b, 14
load_name:
    ld      a, (hl)
    ld      c, a
    ld      a, (de)
    cp      c
    jr      nz, load_header             ; another file's: on to the next header
    or      c
    jr      z, load_found               ; both ended
    inc     hl
    inc     de
    djnz    load_name
load_found:
    ld      c, (ix + 0)
    ld      b, (ix + 1)                 ; the user bytes
    ld      a, b
    or      a
    jr      nz, load_user_big
    ld      a, c
    cp      97
    jr      c, load_user_ok
load_user_big:
    ld      bc, 96
load_user_ok:
    ld      a, b
    or      c
    jr      z, load_data
    ld      e, (ix + 2)
    ld      d, (ix + 3)
    ld      hl, tp_fcb + $20
    ldir
load_data:
    ld      l, (ix + 6)
    ld      h, (ix + 7)
    ld      c, (ix + 4)
    ld      b, (ix + 5)
    ld      e, TAPE_DATA
    call    asm_tape_rx_block
    ld      hl, (tp_got)                ; the bytes read
    jr      nc, load_done               ; (all of them, with a good checksum)
    ld      c, (ix + 4)
    ld      b, (ix + 5)
    or      a
    sbc     hl, bc
    add     hl, bc
    jr      nz, load_done
    dec     hl                          ; (a bad checksum after all the bytes is not a whole file)
    jr      load_done
load_none:
    ld      hl, -1
load_done:
    pop     ix
    call    l_pop_ei
    ret

fcb_clear:
    ld      hl, tp_fcb
    ld      de, tp_fcb + 1
    ld      bc, 127
    ld      (hl), 0
    ldir
    ld      a, 1
    ld      (tp_fcb), a                 ; type 1
    ret

    SECTION bss_clib
tp_fcb:     defs    128
tp_ptr:     defw    0
tp_len:     defw    0
tp_sum:     defw    0
tp_ones:    defw    0
tp_got:     defw    0
tp_check:   defw    0
tp_mark:    defb    0
tp_n:       defb    0
