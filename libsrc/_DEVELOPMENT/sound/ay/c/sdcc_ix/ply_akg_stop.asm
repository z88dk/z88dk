;;
;; C stubs for Arkos invocation from zcc
;;

section code_sound_ay

;; public C symbols, matching .h header file
PUBLIC ply_akg_stop

;; external Arkos 2 entry points
EXTERN asm_smc_PLY_AKG_STOP

;;
;; void ply_akg_stop( void );
;;
ply_akg_stop:
        push ix         ; preserve IX for sdcc_ix
        call asm_smc_PLY_AKG_STOP
        pop ix
        ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ply_akg_stop
defc _ply_akg_stop = ply_akg_stop
ENDIF
