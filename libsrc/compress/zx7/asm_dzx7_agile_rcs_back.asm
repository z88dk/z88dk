
; ===============================================================
; Feb 2016 by Einar Saukas - BACKWARDS VARIANT
; "Agile" integrated RCS+ZX7 decoder by Einar Saukas (129 bytes)
; ===============================================================
;
; void dzx7_agile_rcs_back(void *src, void *dst)
;
; Decompress backwards the compressed block at last address src
; to last address dst.
;
; ===============================================================

SECTION code_clib
SECTION code_compress_zx7

PUBLIC asm_dzx7_agile_rcs_back

EXTERN l_ret

asm_dzx7_agile_rcs_back:

   ; enter : hl = void *src
   ;         de = void *dst
   ;
   ; exit  : hl = & previous uncompressed block
   ;
   ; uses  : af, bc, de, hl

        ld      a, $80

dzx7a_copy_byte_loop1_b:

        push af ; ex      af, af'

        call    dzx7a_copy_byte_b       ; copy literal byte

dzx7a_main_loop1_b:

        pop af ; ex      af, af'

        add     a, a                    ; check next bit
        call    z, dzx7a_load_bits_b    ; no more bits left?
        jr      nc, dzx7a_copy_byte_loop1_b ; next bit indicates either literal or sequence

; determine number of bits used for length (Elias gamma coding)

        push    de
        ld      bc, 1
        ld      d, b

dzx7a_len_size_loop_b:

        inc     d
        add     a, a                    ; check next bit
        call    z, dzx7a_load_bits_b    ; no more bits left?
        jr      nc, dzx7a_len_size_loop_b
        jp      dzx7a_len_value_start_b

; determine length

dzx7a_len_value_loop_b:

        add     a, a                    ; check next bit
        call    z, dzx7a_load_bits_b    ; no more bits left?
        rl      c
        rl      b
;;        jr      c, dzx7a_exit_b         ; check end marker
        jp      c, l_ret - 1

dzx7a_len_value_start_b:

        dec     d
        jr      nz, dzx7a_len_value_loop_b
        inc     bc                      ; adjust length

; determine offset

        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        dec     hl

IF __z80_cpu_info & $02

        defb $cb, $33                   ; opcode for undocumented instruction "SLL E" aka "SLS E"

ELSE

        sla e
        inc e

ENDIF

        jr      nc, dzx7a_offset_end_b  ; if offset flag is set, load 4 extra bits
        add     a, a                    ; check next bit
        call    z, dzx7a_load_bits_b    ; no more bits left?
        rl      d                       ; insert first bit into D
        add     a, a                    ; check next bit
        call    z, dzx7a_load_bits_b    ; no more bits left?
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        call    z, dzx7a_load_bits_b    ; no more bits left?
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        call    z, dzx7a_load_bits_b    ; no more bits left?
        ccf
        jr      c, dzx7a_offset_end_b
        inc     d                       ; equivalent to adding 128 to DE

dzx7a_offset_end_b:

        rr      e                       ; insert inverted fourth bit into E

; copy previous sequence

        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        adc     hl, de                  ; HL = destination + offset + 1
        pop     de                      ; DE = destination

        push af  ; ex      af, af'

dzx7a_copy_bytes_b:

        push    hl
        ex      de, hl
        call    dzx7a_convert_b
        ex      de, hl
        call    dzx7a_copy_byte_b
        pop     hl
        dec     hl
        jp      pe, dzx7a_copy_bytes_b

        pop af  ;

        pop     hl                      ; restore source address (compressed data)
;;        jr      dzx7a_main_loop1_b
        jr      dzx7a_main_loop1_b+1

dzx7a_load_bits_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        ret

dzx7a_copy_byte_b:

        push    de
        call    dzx7a_convert_b
        ldd

dzx7a_exit_b:

        pop     de
        dec     de
        ret

; Convert an RCS address 010RRccc ccrrrppp to screen address 010RRppp rrrccccc

dzx7a_convert_b:

        ld      a, d                    ; A = 010RRccc
        cp      $58
        ret     nc
        xor     e
        and     $f8
        xor     e                       ; A = 010RRppp
        push    af
        xor     d
        xor     e                       ; A = ccrrrccc
        rlca
        rlca                            ; A = rrrccccc
        pop     de                      ; D = 010RRppp
        ld      e, a                    ; E = rrrccccc
        ret
