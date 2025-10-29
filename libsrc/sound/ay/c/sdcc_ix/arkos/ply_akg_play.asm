;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC _ply_akg_play

;; external Arkos 2 entry points
EXTERN asm_smc_PLY_AKG_PLAY

;;
;; void ply_akg_play( void );
;;
_ply_akg_play:
        push ix         ; preserve IX for sdcc_ix
        call asm_smc_PLY_AKG_PLAY
        pop ix
        ret
