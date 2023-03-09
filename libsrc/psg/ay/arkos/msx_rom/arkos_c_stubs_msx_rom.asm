;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC _msx_rom_ply_akg_init
PUBLIC _msx_rom_ply_akg_play
PUBLIC _msx_rom_ply_akg_stop
PUBLIC _msx_rom_ply_akg_initsoundeffects
PUBLIC _msx_rom_ply_akg_playsoundeffect

;; external Arkos 2 entry points
EXTERN asm_msx_rom_PLY_AKG_INIT
EXTERN asm_msx_rom_PLY_AKG_INITSOUNDEFFECTS
EXTERN asm_msx_rom_PLY_AKG_PLAY
EXTERN asm_msx_rom_PLY_AKG_PLAYSOUNDEFFECT
EXTERN asm_msx_rom_PLY_AKG_STOP


;;
;; void ply_akg_init( void *song, uint8_t subsong ) __z88dk_callee __smallc;
;;   (params pushed on the stack left to right, all 16-bit)
;;
_msx_rom_ply_akg_init:
	pop bc		; BC = retaddr
	pop de		; E = subsong number
	pop hl		; HL = song address
	ld a,e		; A = subsong number
	push bc		; restore retaddr
	jp asm_msx_rom_PLY_AKG_INIT

;;
;; void ply_akg_play( void );
;;
defc _msx_rom_ply_akg_play = asm_msx_rom_PLY_AKG_PLAY

;;
;; void ply_akg_stop( void );
;;
defc _msx_rom_ply_akg_stop = asm_msx_rom_PLY_AKG_STOP


;;
;; void ply_akg_initsoundeffects( void *effects_table ) __z88dk_fastcall;
;;   (param in HL)
;;
defc _msx_rom_ply_akg_initsoundeffects = asm_msx_rom_PLY_AKG_INITSOUNDEFFECTS

;;
;; void ply_akg_playsoundeffect( uint16_t effect, uint16_t channel, uint16_t inv_volume ) __z88dk_callee __smallc;
;;   (params pushed on the stack left to right, all 16-bit)
	;;
_msx_rom_ply_akg_playsoundeffect:
        pop hl          ; HL = retaddr

        pop bc
        ld b,c          ; B = inv volume
        pop de
        ld c,e          ; C = num channel
        pop de
        ld a,e          ; A = sound effect number

        push hl         ; restore retaddr
        jp asm_msx_rom_PLY_AKG_PLAYSOUNDEFFECT
