;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC ply_akg_play
PUBLIC _ply_akg_play

;; external Arkos 2 entry points
EXTERN asm_smc_PLY_AKG_PLAY

;;
;; void ply_akg_play( void );
;;
defc ply_akg_play = asm_smc_PLY_AKG_PLAY
defc _ply_akg_play = ply_akg_play
