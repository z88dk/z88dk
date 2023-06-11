
; 	ANSI Video handling for the Gemini Galaxy

        SECTION code_clib

        PUBLIC  ansi_del_line
        EXTERN  ansi_del_line_generic

        defc    ansi_del_line = ansi_del_line_generic
