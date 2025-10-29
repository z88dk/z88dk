;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC _ply_rom_akg_play

;; external Arkos 2 entry points
EXTERN asm_rom_PLY_AKG_PLAY

;;
;; void ply_akg_play( void );
;;
defc _ply_rom_akg_play = asm_rom_PLY_AKG_PLAY
