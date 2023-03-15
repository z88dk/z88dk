;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC ply_rom_akg_initsoundeffects

;; external Arkos 2 entry points
EXTERN asm_rom_PLY_AKG_INITSOUNDEFFECTS

;;
;; void ply_akg_initsoundeffects( void *effects_table ) __z88dk_fastcall;
;;   (param in HL)
;;
ply_rom_akg_initsoundeffects:
        push ix         ; preserve IX for sdcc_ix
        call asm_rom_PLY_AKG_INITSOUNDEFFECTS
        pop ix
        ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ply_rom_akg_initsoundeffects
defc _ply_rom_akg_initsoundeffects = ply_rom_akg_initsoundeffects
ENDIF
