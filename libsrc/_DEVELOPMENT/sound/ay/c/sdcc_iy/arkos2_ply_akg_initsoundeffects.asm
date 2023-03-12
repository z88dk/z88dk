IF !__CPU_INTEL__ && !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	_ply_akg_initsoundeffects

EXTERN PLY_AKG_INITSOUNDEFFECTS

;;
;; void ply_akg_initsoundeffects( void *effects_table ) __z88dk_fastcall;
;;   (param in HL)
;;
defc _ply_akg_initsoundeffects = PLY_AKG_INITSOUNDEFFECTS

ENDIF
