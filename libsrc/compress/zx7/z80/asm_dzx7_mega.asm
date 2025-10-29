
; ===============================================================
; Dec 2012 by Einar Saukas
; "Mega" version (246 bytes, 30% faster)
; ===============================================================
; 
; void dzx7_mega(void *src, void *dst)
;
; Decompress the compressed block at address src to address dst.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_compress_zx7

PUBLIC asm_dzx7_mega

EXTERN l_ret

asm_dzx7_mega:

   ; enter : hl = void *src
   ;         de = void *dst
   ;
   ; exit  : hl = & following uncompressed block
   ;
   ; uses  : af, bc, de, hl

        ld      a, $80
        
dzx7m_copy_byte_loop_ev:

        ldi                             ; copy literal byte
        
dzx7m_main_loop_ev:

        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits1     ; no more bits left?
        jr      c, dzx7m_len_size_start_od ; next bit indicates either literal or sequence

dzx7m_copy_byte_loop_od:

        ldi                             ; copy literal byte
        
dzx7m_main_loop_od:

        add     a, a                    ; check next bit
        jr      nc, dzx7m_copy_byte_loop_ev ; next bit indicates either literal or sequence

dzx7m_len_size_start_ev:

; determine number of bits used for length (Elias gamma coding)

        push    de
        ld      bc, 1
        ld      d, b
        
dzx7m_len_size_loop_ev:

        inc     d
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits2_ev  ; no more bits left?
        jr      nc, dzx7m_len_size_loop_ev
        jp      dzx7m_len_value_start_ev

dzx7m_len_size_start_od:

; determine number of bits used for length (Elias gamma coding)

        push    de
        ld      bc, 1
        ld      d, b
        
dzx7m_len_size_loop_od:

        inc     d
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits2_od  ; no more bits left?
        jr      nc, dzx7m_len_size_loop_od
        jp      dzx7m_len_value_start_od

; determine length

dzx7m_len_value_loop_ev:

        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits3_ev  ; no more bits left?
        rl      c
        rl      b
;;        jr      c, dzx7m_exit_ev        ; check end marker
        jp      c, l_ret - 1


dzx7m_len_value_start_ev:

        dec     d
        jr      nz, dzx7m_len_value_loop_ev
        inc     bc                      ; adjust length
        
dzx7m_offset_start_od:

; determine offset

        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        inc     hl
        
IF __CPU_INFO & $01

        defb $cb, $33                   ; opcode for undocumented instruction "SLL E" aka "SLS E"

ELSE

        sla e
        inc e

ENDIF
        
        jr      nc, dzx7m_offset_end_od ; if offset flag is set, load 4 extra bits
        add     a, a                    ; check next bit
        rl      d                       ; insert first bit into D
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits4     ; no more bits left?
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits5     ; no more bits left?
        ccf
        jr      c, dzx7m_offset_end_od
        
dzx7m_offset_inc_od:

        inc     d                       ; equivalent to adding 128 to DE
        
dzx7m_offset_end_od:

        rr      e                       ; insert inverted fourth bit into E
        
; copy previous sequence

        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        sbc     hl, de                  ; HL = destination - offset - 1
        pop     de                      ; DE = destination
        ldir
        pop     hl                      ; restore source address (compressed data)
        jp      dzx7m_main_loop_od

dzx7m_load_bits1:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        jr      c, dzx7m_len_size_start_od ; next bit indicates either literal or sequence
        jp      dzx7m_copy_byte_loop_od

dzx7m_load_bits2_ev:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        jr      nc, dzx7m_len_size_loop_ev
        jp      dzx7m_len_value_start_ev

dzx7m_load_bits2_od:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        jr      nc, dzx7m_len_size_loop_od
        jp      dzx7m_len_value_start_od

dzx7m_load_bits3_ev:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        rl      c
        rl      b
        jp      nc, dzx7m_len_value_start_ev ; check end marker
        
dzx7m_exit_ev:

        pop     de
        ret

dzx7m_load_bits4:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        ccf
        jr      c, dzx7m_offset_end_od
        jp      dzx7m_offset_inc_od

dzx7m_load_bits5:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        ccf
        jr      c, dzx7m_offset_end_od
        jp      dzx7m_offset_inc_od

; determine length

dzx7m_len_value_loop_od:

        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits3_od  ; no more bits left?
        rl      c
        rl      b
;;        jr      c, dzx7m_exit_od        ; check end marker
        jp      c, l_ret - 1
        
dzx7m_len_value_start_od:

        dec     d
        jr      nz, dzx7m_len_value_loop_od
        inc     bc                      ; adjust length
        
dzx7m_offset_start_ev:

; determine offset

        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        inc     hl
        
IF __CPU_INFO & $01

        defb $cb, $33                   ; opcode for undocumented instruction "SLL E" aka "SLS E"

ELSE

        sla e
        inc e

ENDIF
        
        jr      nc, dzx7m_offset_end_ev ; if offset flag is set, load 4 extra bits
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits6     ; no more bits left?
        rl      d                       ; insert first bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        jr      z, dzx7m_load_bits7     ; no more bits left?
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        ccf
        jr      c, dzx7m_offset_end_ev
        
dzx7m_offset_inc_ev:

        inc     d                       ; equivalent to adding 128 to DE
        
dzx7m_offset_end_ev:

        rr      e                       ; insert inverted fourth bit into E
        
; copy previous sequence

        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        sbc     hl, de                  ; HL = destination - offset - 1
        pop     de                      ; DE = destination
        ldir
        pop     hl                      ; restore source address (compressed data)
        jp      dzx7m_main_loop_ev

dzx7m_load_bits3_od:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        rl      c
        rl      b
        jp      nc, dzx7m_len_value_start_od ; check end marker
        
dzx7m_exit_od:

        pop     de
        ret

dzx7m_load_bits6:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        rl      d                       ; insert first bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert second bit into D
        add     a, a                    ; check next bit
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        ccf
        jr      c, dzx7m_offset_end_ev
        jp      dzx7m_offset_inc_ev

dzx7m_load_bits7:

        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        rl      d                       ; insert third bit into D
        add     a, a                    ; check next bit
        ccf
        jr      c, dzx7m_offset_end_ev
        jp      dzx7m_offset_inc_ev
