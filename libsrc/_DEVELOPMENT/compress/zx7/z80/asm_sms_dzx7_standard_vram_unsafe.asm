
; ===============================================================
; Dec 2012 by Einar Saukas, Antonio Villena & Metalbrain
; "Standard" version (70 bytes)
; modified for sms vram by aralbrec
; ===============================================================
; 
; unsigned int sms_dzx7_standard_vram(void *src, unsigned int dst)
;
; Decompress the compressed block at memory address src to vram
; address dst.  VRAM addresses are assumed to be stable.
;
; This decompression is unsafe because it does not satisfy
; minimum VDP timing.  Decompression can only be done if the
; video display is disabled.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_compress_zx7

PUBLIC asm_dzx7_standard_vram_unsafe

EXTERN asm_sms_set_vram_write_de, asm_sms_ldir_vram_to_vram_unsafe, l_ret

asm_dzx7_standard_vram_unsafe:

   ; enter : hl = void *src
   ;         de = unsigned int dst in vram
   ;
   ; exit  : hl = & following uncompressed block in vram
   ;
   ; uses  : af, bc, de, hl, af'

        call asm_sms_set_vram_write_de
        
        ld c,__IO_VDP_DATA
        ld a,$80
        
dzx7s_copy_byte_loop:

        ;;ldi                              ; copy literal byte
        outi
        inc de
        
dzx7s_main_loop:

        call    dzx7s_next_bit
        jr      nc, dzx7s_copy_byte_loop ; next bit indicates either literal or sequence

; determine number of bits used for length (Elias gamma coding)

        push    de
        ld      bc, 0
        ld      d, b
        
dzx7s_len_size_loop:

        inc     d
        call    dzx7s_next_bit
        jr      nc, dzx7s_len_size_loop

; determine length

dzx7s_len_value_loop:

        call    nc, dzx7s_next_bit
        rl      c
        rl      b
;;        jr      c, dzx7s_exit           ; check end marker
        jp      c, l_ret - 1
        dec     d
        jr      nz, dzx7s_len_value_loop
        inc     bc                      ; adjust length

; determine offset

        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        inc     hl

IF __CPU_INFO & $01

        defb $cb, $33                   ; opcode for undocumented instruction "SLL E" aka "SLS E"

ELSE

        sla e
        inc e

ENDIF

        jr      nc, dzx7s_offset_end    ; if offset flag is set, load 4 extra bits
        ld      d, $10                  ; bit marker to load 4 bits
        
dzx7s_rld_next_bit:

        call    dzx7s_next_bit
        rl      d                       ; insert next bit into D
        jr      nc, dzx7s_rld_next_bit  ; repeat 4 times, until bit marker is out
        inc     d                       ; add 128 to DE
        srl	    d                       ; retrieve fourth bit from D
        
dzx7s_offset_end:

        rr      e                       ; insert fourth bit into E

; copy previous sequence

        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        sbc     hl, de                  ; HL = destination - offset - 1
        pop     de                      ; DE = destination
        ;;ldir
        call asm_sms_ldir_vram_to_vram_unsafe
        
;;dzx7s_exit:

        call asm_sms_set_vram_write_de
        ld c,__IO_VDP_DATA

        pop     hl                      ; restore source address (compressed data)
        jr      dzx7s_main_loop
        
dzx7s_next_bit:

        add     a, a                    ; check next bit
        ret     nz                      ; no more bits left?
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        ret
