
	SECTION		code_graphics
	PUBLIC		generic_console_set_paper

	EXTERN		__MODE3_attr
	EXTERN		__MODE2_attr


generic_console_set_paper:
	and	15
	ld	(__MODE3_attr + 1),a
	and	3
	ld	(__MODE2_attr + 1),a
	ret
