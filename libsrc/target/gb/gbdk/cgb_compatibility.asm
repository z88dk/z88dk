;       .title  "CGB support"
;       .module CGB

        MODULE  cgb_compatibility

        PUBLIC  cgb_compatibility
        PUBLIC  _cgb_compatibility

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

;void __LIB__ cgb_compatibility(void);
cgb_compatibility:                     ; Banked
_cgb_compatibility:                     ; Banked
        LD      A,0x80
        LDH     (BCPS),A       ; Set default bkg palette
        LD      A,0xff         ; White
        LDH     (BCPD),A
        LD      A,0x7f
        LDH     (BCPD),A
        LD      A,0xb5         ; Light gray
        LDH     (BCPD),A
        LD      A,0x56
        LDH     (BCPD),A
        LD      A,0x4a         ; Dark gray
        LDH     (BCPD),A
        LD      A,0x29
        LDH     (BCPD),A
        LD      A,0x00         ; Black
        LDH     (BCPD),A
        LD      A,0x00
        LDH     (BCPD),A

        LD      A,0x80
        LDH     (OCPS),A       ; Set default sprite palette
        LD      A,0xff         ; White
        LDH     (OCPD),A
        LD      A,0x7f
        LDH     (OCPD),A
        LD      A,0xb5         ; Light gray
        LDH     (OCPD),A
        LD      A,0x56
        LDH     (OCPD),A
        LD      A,0x4a         ; Dark gray
        LDH     (OCPD),A
        LD      A,0x29
        LDH     (OCPD),A
        LD      A,0x00         ; Black
        LDH     (OCPD),A
        LD      A,0x00
        LDH     (OCPD),A

        RET
