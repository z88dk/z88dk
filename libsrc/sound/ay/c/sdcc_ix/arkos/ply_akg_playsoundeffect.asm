;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC _ply_akg_playsoundeffect

;; external Arkos 2 entry points
EXTERN asm_smc_PLY_AKG_PLAYSOUNDEFFECT

;;
;; void ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee;
;;   SDCC: (params pushed on the stack right to left, all 16-bit)
;;
_ply_akg_playsoundeffect:
        pop hl          ; HL = retaddr
        pop de
        ld a,e          ; A = sound effect number
        pop de
        ld c,e          ; C = num channel
        pop de
        ld b,e          ; B = inv volume
        push hl         ; restore retaddr

        push ix         ; preserve IX for sdcc_ix
        call asm_smc_PLY_AKG_PLAYSOUNDEFFECT
        pop ix
        ret
