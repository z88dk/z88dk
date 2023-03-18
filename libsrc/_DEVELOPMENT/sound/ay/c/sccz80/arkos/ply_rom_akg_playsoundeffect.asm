;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC ply_rom_akg_playsoundeffect

;; external Arkos 2 entry points
EXTERN asm_rom_PLY_AKG_PLAYSOUNDEFFECT

;;
;; void ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee __smallc;
;;   (params pushed on the stack left to right, all 16-bit)
;;
ply_rom_akg_playsoundeffect:
        pop hl          ; HL = retaddr

        pop bc
        ld b,c          ; B = inv volume
        pop de
        ld c,e          ; C = num channel
        pop de
        ld a,e          ; A = sound effect number

        push hl         ; restore retaddr
        jp asm_rom_PLY_AKG_PLAYSOUNDEFFECT

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ply_rom_akg_playsoundeffect
defc _ply_rom_akg_playsoundeffect = ply_rom_akg_playsoundeffect
ENDIF
