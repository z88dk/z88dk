
        SECTION code_graphics
        PUBLIC  generic_console_xypos

        defc    DISPLAY = 0xF800


; Entry: b = y, c = x
; Exit: hl = screen position
generic_console_xypos:
        ld      hl,DISPLAY - 80
        ld      de,80
        inc     b
generic_console_printc_1:
        add     hl,de
        djnz    generic_console_printc_1
generic_console_printc_3:
        add     hl,bc                   ;hl now points to address in display
        ret
