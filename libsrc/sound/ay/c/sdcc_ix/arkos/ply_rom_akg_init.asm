;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC _ply_rom_akg_init

;; external Arkos 2 entry points
EXTERN asm_rom_PLY_AKG_INIT

;;
;; void ply_akg_init( void *song, uint16_t subsong ) __z88dk_callee;
;;  SDCC:  (params pushed on the stack right to left, all 16-bit)
;;
_ply_rom_akg_init:
        pop bc          ; BC = retaddr
        pop hl          ; HL = song address
        pop de          ; E = subsong number
        ld a,e          ; A = subsong number
        push bc         ; restore retaddr

        push ix         ; preserve IX for sdcc_ix
        call asm_rom_PLY_AKG_INIT
        pop ix
        ret
