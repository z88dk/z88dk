IF !__CPU_INTEL__ && !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	_ply_akg_init

EXTERN PLY_AKG_INIT

;;
;; void ply_akg_init( void *song, uint8_t subsong ) __z88dk_callee;
;;   (params pushed on the stack right to left, all 16-bit)
;;
_ply_akg_init:
        pop bc          ; BC = retaddr

        pop hl          ; HL = song address
        pop de
        ld a,e          ; A = subsong number

        push bc         ; restore retaddr
        jp PLY_AKG_INIT

ENDIF
