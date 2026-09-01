//------------------------------------------------------------------------------
// Start with some ASM to check that a REM line is created
//------------------------------------------------------------------------------

#ASM
		ex af, af'			; tick is removed in preprocessing
#ENDASM

#ASM
		ret
#ENDASM

