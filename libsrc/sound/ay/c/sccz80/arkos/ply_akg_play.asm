;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC ply_akg_play

;; external Arkos 2 entry points
EXTERN asm_smc_PLY_AKG_PLAY

;;
;; void ply_akg_play( void );
;;
defc ply_akg_play = asm_smc_PLY_AKG_PLAY

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ply_akg_play
defc _ply_akg_play = ply_akg_play
ENDIF
