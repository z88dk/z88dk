;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC _msx_ram_ply_akg_play

;; external Arkos 2 entry points
EXTERN asm_msx_ram_PLY_AKG_PLAY

;;
;; void ply_akg_play( void );
;;
defc _msx_ram_ply_akg_play = asm_msx_ram_PLY_AKG_PLAY
