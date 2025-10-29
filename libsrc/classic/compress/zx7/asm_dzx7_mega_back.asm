
; ===============================================================
; Feb 2016 by Einar Saukas
; "Mega" version (246 bytes, 30% faster) - BACKWARDS VARIANT
; ===============================================================
;
; void dzx7_mega_back(void *src, void *dst)
;
; Decompress backwards the compressed block at last address src 
; to last address dst.
;
; ===============================================================

SECTION code_clib
SECTION code_compress_zx7

PUBLIC asm_dzx7_mega_back

EXTERN l_ret

asm_dzx7_mega_back:

   ; enter : hl = void *src
   ;         de = void *dst
   ;
   ; exit  : hl = & previous uncompressed block
   ;
   ; uses  : af, bc, de, hl

        ld      a, $80

dzx7m_copy_byte_loop_ev_b:

        ldd                             ; copy literal byte

dzx7m_main_loop_ev_b:

        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits1_b   ; no more bits left?
        jr      c, dzx7m_len_size_start_od_b ; next bit indicates either literal or sequence

dzx7m_copy_byte_loop_od_b:

        ldd                             ; copy literal byte

dzx7m_main_loop_od_b:

        add     a, a                    ; check next bit
        jr      nc, dzx7m_copy_byte_loop_ev_b ; next bit indicates either literal or sequence

dzx7m_len_size_start_ev_b:

; determine number of bits used for length (Elias gamma coding)

        push    de
        ld      bc, 1
        ld      d, b

dzx7m_len_size_loop_ev_b:

        inc     d
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits2_ev_b ; no more bits left?
        jr      nc, dzx7m_len_size_loop_ev_b
        jp      dzx7m_len_value_start_ev_b

dzx7m_len_size_start_od_b:

; determine number of bits used for length (Elias gamma coding)

        push    de
        ld      bc, 1
        ld      d, b

dzx7m_len_size_loop_od_b:

        inc     d
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits2_od_b ; no more bits left?
        jr      nc, dzx7m_len_size_loop_od_b
        jp      dzx7m_len_value_start_od_b

; determine length

dzx7m_len_value_loop_ev_b:

        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits3_ev_b ; no more bits left?
        rl      c
        rl      b
;;        jr      c, dzx7m_exit_ev_b      ; check end marker
        jp      c, l_ret - 1


dzx7m_len_value_start_ev_b:

        dec     d
        jr      nz, dzx7m_len_value_loop_ev_b
        inc     bc                      ; adjust length

dzx7m_offset_start_od_b:

; determine offset

        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        dec     hl

IF __z80_cpu_info & $02

        defb $cb, $33                   ; opcode for undocumented instruction "SLL E" aka "SLS E"

ELSE

        sla e
        inc e

ENDIF

        jr      nc, dzx7m_offset_end_od_b ; if offset flag is set, load 4 extra bits
        add     a, a                    ; check next bit
        rl      d                       ; insert first bit into D
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits4_b   ; no more bits left?
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits5_b   ; no more bits left?
        ccf
        jr      c, dzx7m_offset_end_od_b

dzx7m_offset_inc_od_b:

        inc     d                       ; equivalent to adding 128 to DE

dzx7m_offset_end_od_b:

        rr      e                       ; insert inverted fourth bit into E

; copy previous sequence

        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        adc     hl, de                  ; HL = destination + offset + 1
        pop     de                      ; DE = destination
        lddr
        pop     hl                      ; restore source address (compressed data)
        jp      dzx7m_main_loop_od_b

dzx7m_load_bits1_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        jr      c, dzx7m_len_size_start_od_b ; next bit indicates either literal or sequence
        jp      dzx7m_copy_byte_loop_od_b

dzx7m_load_bits2_ev_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        jr      nc, dzx7m_len_size_loop_ev_b
        jp      dzx7m_len_value_start_ev_b

dzx7m_load_bits2_od_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        jr      nc, dzx7m_len_size_loop_od_b
        jp      dzx7m_len_value_start_od_b

dzx7m_load_bits3_ev_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        rl      c
        rl      b
        jp      nc, dzx7m_len_value_start_ev_b ; check end marker

dzx7m_exit_ev_b:

        pop     de
        ret

dzx7m_load_bits4_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        ccf
        jr      c, dzx7m_offset_end_od_b
        jp      dzx7m_offset_inc_od_b

dzx7m_load_bits5_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        ccf
        jr      c, dzx7m_offset_end_od_b
        jp      dzx7m_offset_inc_od_b

; determine length

dzx7m_len_value_loop_od_b:

        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits3_od_b ; no more bits left?
        rl      c
        rl      b
;;        jr      c, dzx7m_exit_od_b      ; check end marker
        jp      c, l_ret - 1

dzx7m_len_value_start_od_b:

        dec     d
        jr      nz, dzx7m_len_value_loop_od_b
        inc     bc                      ; adjust length

dzx7m_offset_start_ev_b:

; determine offset

        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        dec     hl

IF __z80_cpu_info & $02

        defb $cb, $33                   ; opcode for undocumented instruction "SLL E" aka "SLS E"

ELSE

        sla e
        inc e

ENDIF

        jr      nc, dzx7m_offset_end_ev_b ; if offset flag is set, load 4 extra bits
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits6_b   ; no more bits left?
        rl      d                       ; insert first bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits7_b   ; no more bits left?
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        ccf
        jr      c, dzx7m_offset_end_ev_b

dzx7m_offset_inc_ev_b:

        inc     d                       ; equivalent to adding 128 to DE

dzx7m_offset_end_ev_b:

        rr      e                       ; insert inverted fourth bit into E

; copy previous sequence

        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        adc     hl, de                  ; HL = destination + offset + 1
        pop     de                      ; DE = destination
        lddr
        pop     hl                      ; restore source address (compressed data)
        jp      dzx7m_main_loop_ev_b

dzx7m_load_bits3_od_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        rl      c
        rl      b
        jp      nc, dzx7m_len_value_start_od_b ; check end marker

dzx7m_exit_od_b:

        pop     de
        ret

dzx7m_load_bits6_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        rl      d                       ; insert first bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        ccf
        jr      c, dzx7m_offset_end_ev_b
        jp      dzx7m_offset_inc_ev_b

dzx7m_load_bits7_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        ccf
        jr      c, dzx7m_offset_end_ev_b
        jp      dzx7m_offset_inc_ev_b
