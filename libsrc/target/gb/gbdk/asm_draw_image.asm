
	SECTION	code_driver

	PUBLIC	asm_draw_image
	GLOBAL	copy_vram

        ;; Draw a full-screen image at (BC)
asm_draw_image:
        LD      HL,0x8000+0x10*0x10
        LD      DE,0x1680
        CALL    copy_vram      ; Move the charset
        RET
