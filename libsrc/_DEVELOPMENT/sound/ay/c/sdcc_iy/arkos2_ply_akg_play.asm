IF !__CPU_INTEL__ && !__CPU_GBZ80__

	SECTION	code_sound_ay

	PUBLIC	_ply_akg_play

EXTERN PLY_AKG_PLAY

;;
;; void ply_akg_play( void );
;;    this one must be called with interrupts disabled!
defc _ply_akg_play = PLY_AKG_PLAY

ENDIF
