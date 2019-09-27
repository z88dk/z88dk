


        MODULE  lcd

        PUBLIC  lcd


        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

        ;; Is the STAT check required, as we are already in the HBL?
lcd:
        LDH     A,(STAT)
        BIT     1,A
        JR      NZ,lcd

        LDH     A,(LCDC)
        AND     @11101111       ; Set BG Chr to 0x8800
        LDH     (LCDC),A

        RET
