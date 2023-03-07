IF !__CPU_INTEL__ && !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	_ply_akg_stop

EXTERN PLY_AKG_STOP

;;
;; void ply_akg_stop( void );
;;
defc _ply_akg_stop = PLY_AKG_STOP

ENDIF
