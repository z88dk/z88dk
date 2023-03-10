;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC _msx_ram_ply_akg_initsoundeffects

;; external Arkos 2 entry points
EXTERN asm_msx_ram_PLY_AKG_INITSOUNDEFFECTS

;;
;; void ply_akg_initsoundeffects( void *effects_table ) __z88dk_fastcall;
;;   (param in HL)
;;
defc _msx_ram_ply_akg_initsoundeffects = asm_msx_ram_PLY_AKG_INITSOUNDEFFECTS
