
; ===============================================================
; Feb 2016 by Einar Saukas
; "Turbo" version (89 bytes, 25% faster) - BACKWARDS VARIANT
; ===============================================================
;
; void dzx7_turbo_back(void *src, void *dst)
;
; Decompress backwards the compressed block at last address src 
; to last address dst.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_compress_zx7

PUBLIC asm_dzx7_turbo_back

EXTERN l_ret

asm_dzx7_turbo_back:

   ; enter : hl = void *src
   ;         de = void *dst
   ;
   ; exit  : hl = & previous uncompressed block
   ;
   ; uses  : af, bc, de, hl

        ld      a, $80

dzx7t_copy_byte_loop_b:

        ldd                             ; copy literal byte

dzx7t_main_loop_b:

        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits_b    ; no more bits left?
        jr      nc, dzx7t_copy_byte_loop_b ; next bit indicates either literal or sequence

; determine number of bits used for length (Elias gamma coding)

        push    de
        ld      bc, 1
        ld      d, b

dzx7t_len_size_loop_b:

        inc     d
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits_b    ; no more bits left?
        jr      nc, dzx7t_len_size_loop_b
        jp      dzx7t_len_value_start_b

; determine length

dzx7t_len_value_loop_b:

        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits_b    ; no more bits left?
        rl      c
        rl      b
;;        jr      c, dzx7t_exit_b         ; check end marker
        jp      c, l_ret - 1

dzx7t_len_value_start_b:

        dec     d
        jr      nz, dzx7t_len_value_loop_b
        inc     bc                      ; adjust length

; determine offset

        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        dec     hl

IF __CPU_INFO & $01

        defb $cb, $33                   ; opcode for undocumented instruction "SLL E" aka "SLS E"

ELSE

        sla e
        inc e

ENDIF

        jr      nc, dzx7t_offset_end_b  ; if offset flag is set, load 4 extra bits
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits_b    ; no more bits left?
        rl      d                       ; insert first bit into D
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits_b    ; no more bits left?
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits_b    ; no more bits left?
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        call    z, dzx7t_load_bits_b    ; no more bits left?
        ccf
        jr      c, dzx7t_offset_end_b
        inc     d                       ; equivalent to adding 128 to DE

dzx7t_offset_end_b:

        rr      e                       ; insert inverted fourth bit into E

; copy previous sequence

        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        adc     hl, de                  ; HL = destination + offset + 1
        pop     de                      ; DE = destination
        lddr

dzx7t_exit_b:

        pop     hl                      ; restore source address (compressed data)
        jp      nc, dzx7t_main_loop_b

dzx7t_load_bits_b:

        ld      a, (hl)                 ; load another group of 8 bits
        dec     hl
        rla
        ret
