IF !__CPU_INTEL__ && !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	_ply_akg_playsoundeffect

EXTERN PLY_AKG_PLAYSOUNDEFFECT

;;
;; void ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee;
;;   (params pushed on the stack right to left, all 16-bit)
;;
_ply_akg_playsoundeffect:
        pop hl          ; HL = retaddr

        pop de
        ld a,e          ; A = sound effect number
        pop de
        ld c,e          ; C = num channel
        pop bc
        ld b,c          ; B = inv volume

        push hl         ; restore retaddr
        jp PLY_AKG_PLAYSOUNDEFFECT

ENDIF
