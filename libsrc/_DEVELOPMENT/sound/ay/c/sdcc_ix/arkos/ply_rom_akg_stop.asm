;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC _ply_rom_akg_stop

;; external Arkos 2 entry points
EXTERN asm_rom_PLY_AKG_STOP

;;
;; void ply_akg_stop( void );
;;
_ply_rom_akg_stop:
        push ix         ; preserve IX for sdcc_ix
        call asm_rom_PLY_AKG_STOP
        pop ix
        ret
