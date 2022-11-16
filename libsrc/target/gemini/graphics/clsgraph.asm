
        SECTION code_clib

	PUBLIC	cleargraphics
   PUBLIC   _cleargraphics

	EXTERN clg
;
;	$Id: clsgraph.asm $
;

; ******************************************************************
;
;	Clear graphics area
;

.cleargraphics
._cleargraphics

	jp clg
