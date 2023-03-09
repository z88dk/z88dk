;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC _zx_ram_ply_akg_init

;; external Arkos 2 entry points
EXTERN asm_zx_ram_PLY_AKG_INIT

;;
;; void ply_akg_init( void *song, uint8_t subsong ) __z88dk_callee __smallc;
;;   (params pushed on the stack left to right, all 16-bit)
;;
_zx_ram_ply_akg_init:
	pop bc		; BC = retaddr
	pop de		; E = subsong number
	pop hl		; HL = song address
	ld a,e		; A = subsong number
	push bc		; restore retaddr
	jp asm_zx_ram_PLY_AKG_INIT
