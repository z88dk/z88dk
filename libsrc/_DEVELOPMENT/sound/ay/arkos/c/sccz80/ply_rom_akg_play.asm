;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC ply_rom_akg_play

;; external Arkos 2 entry points
EXTERN asm_rom_PLY_AKG_PLAY

;;
;; void ply_akg_play( void );
;;
defc ply_rom_akg_play = asm_rom_PLY_AKG_PLAY

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ply_rom_akg_play
defc _ply_rom_akg_play = ply_rom_akg_play
ENDIF
