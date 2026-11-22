; List of sections for MegaROMs

    IFNDEF CRT_ORG_BANK_00
        defc CRT_ORG_BANK_00 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_01
        defc CRT_ORG_BANK_01 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_02
        defc CRT_ORG_BANK_02 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_03
        defc CRT_ORG_BANK_03 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_04
        defc CRT_ORG_BANK_04 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_05
        defc CRT_ORG_BANK_05 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_06
        defc CRT_ORG_BANK_06 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_07
        defc CRT_ORG_BANK_07 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_08
        defc CRT_ORG_BANK_08 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_09
        defc CRT_ORG_BANK_09 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_0A
        defc CRT_ORG_BANK_0A = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_0B
        defc CRT_ORG_BANK_0B = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_0C
        defc CRT_ORG_BANK_0C = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_0D
        defc CRT_ORG_BANK_0D = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_0E
        defc CRT_ORG_BANK_0E = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_0F
        defc CRT_ORG_BANK_0F = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_10
        defc CRT_ORG_BANK_10 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_11
        defc CRT_ORG_BANK_11 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_12
        defc CRT_ORG_BANK_12 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_13
        defc CRT_ORG_BANK_13 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_14
        defc CRT_ORG_BANK_14 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_15
        defc CRT_ORG_BANK_15 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_16
        defc CRT_ORG_BANK_16 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_17
        defc CRT_ORG_BANK_17 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_18
        defc CRT_ORG_BANK_18 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_19
        defc CRT_ORG_BANK_19 = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_1A
        defc CRT_ORG_BANK_1A = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_1B
        defc CRT_ORG_BANK_1B = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_1C
        defc CRT_ORG_BANK_1C = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_1D
        defc CRT_ORG_BANK_1D = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_1E
        defc CRT_ORG_BANK_1E = $c000
    ENDIF

    IFNDEF CRT_ORG_BANK_1F
        defc CRT_ORG_BANK_1F = $c000
    ENDIF

     SECTION BANK_00
     org $200000 + CRT_ORG_BANK_00
     SECTION CODE_0
     SECTION RODATA_0
     SECTION RODATA_0_align_256
     align 256
     SECTION RODATA_0_align_128
     align 128
     SECTION RODATA_0_align_64
     align 64
     SECTION RODATA_0_align_32
     align 32
     SECTION RODATA_0_align_16
     align 16
     SECTION RODATA_0_align_8
     align 8
     SECTION RODATA_0_align_4
     align 4
     SECTION RODATA_0_align_2
     align 2
     SECTION DATA_0
     SECTION DATA_0_align_256
     align 256
     SECTION DATA_0_align_128
     align 128
     SECTION DATA_0_align_64
     align 64
     SECTION DATA_0_align_32
     align 32
     SECTION DATA_0_align_16
     align 16
     SECTION DATA_0_align_8
     align 8
     SECTION DATA_0_align_4
     align 4
     SECTION DATA_0_align_2
     align 2
     SECTION BSS_0
     SECTION BANK_00_END

     SECTION BANK_01
     org $210000 + CRT_ORG_BANK_01
     SECTION CODE_1
     SECTION RODATA_1
     SECTION RODATA_1_align_256
     align 256
     SECTION RODATA_1_align_128
     align 128
     SECTION RODATA_1_align_64
     align 64
     SECTION RODATA_1_align_32
     align 32
     SECTION RODATA_1_align_16
     align 16
     SECTION RODATA_1_align_8
     align 8
     SECTION RODATA_1_align_4
     align 4
     SECTION RODATA_1_align_2
     align 2
     SECTION DATA_1
     SECTION DATA_1_align_256
     align 256
     SECTION DATA_1_align_128
     align 128
     SECTION DATA_1_align_64
     align 64
     SECTION DATA_1_align_32
     align 32
     SECTION DATA_1_align_16
     align 16
     SECTION DATA_1_align_8
     align 8
     SECTION DATA_1_align_4
     align 4
     SECTION DATA_1_align_2
     align 2
     SECTION BSS_1
     SECTION BANK_01_END

     SECTION BANK_02
     org $220000 + CRT_ORG_BANK_02
     SECTION CODE_2
     SECTION RODATA_2
     SECTION RODATA_2_align_256
     align 256
     SECTION RODATA_2_align_128
     align 128
     SECTION RODATA_2_align_64
     align 64
     SECTION RODATA_2_align_32
     align 32
     SECTION RODATA_2_align_16
     align 16
     SECTION RODATA_2_align_8
     align 8
     SECTION RODATA_2_align_4
     align 4
     SECTION RODATA_2_align_2
     align 2
     SECTION DATA_2
     SECTION DATA_2_align_256
     align 256
     SECTION DATA_2_align_128
     align 128
     SECTION DATA_2_align_64
     align 64
     SECTION DATA_2_align_32
     align 32
     SECTION DATA_2_align_16
     align 16
     SECTION DATA_2_align_8
     align 8
     SECTION DATA_2_align_4
     align 4
     SECTION DATA_2_align_2
     align 2
     SECTION BSS_2
     SECTION BANK_02_END

     SECTION BANK_03
     org $230000 + CRT_ORG_BANK_03
     SECTION CODE_3
     SECTION RODATA_3
     SECTION RODATA_3_align_256
     align 256
     SECTION RODATA_3_align_128
     align 128
     SECTION RODATA_3_align_64
     align 64
     SECTION RODATA_3_align_32
     align 32
     SECTION RODATA_3_align_16
     align 16
     SECTION RODATA_3_align_8
     align 8
     SECTION RODATA_3_align_4
     align 4
     SECTION RODATA_3_align_2
     align 2
     SECTION DATA_3
     SECTION DATA_3_align_256
     align 256
     SECTION DATA_3_align_128
     align 128
     SECTION DATA_3_align_64
     align 64
     SECTION DATA_3_align_32
     align 32
     SECTION DATA_3_align_16
     align 16
     SECTION DATA_3_align_8
     align 8
     SECTION DATA_3_align_4
     align 4
     SECTION DATA_3_align_2
     align 2
     SECTION BSS_3
     SECTION BANK_03_END

     SECTION BANK_04
     org $240000 + CRT_ORG_BANK_04
     SECTION CODE_4
     SECTION RODATA_4
     SECTION RODATA_4_align_256
     align 256
     SECTION RODATA_4_align_128
     align 128
     SECTION RODATA_4_align_64
     align 64
     SECTION RODATA_4_align_32
     align 32
     SECTION RODATA_4_align_16
     align 16
     SECTION RODATA_4_align_8
     align 8
     SECTION RODATA_4_align_4
     align 4
     SECTION RODATA_4_align_2
     align 2
     SECTION DATA_4
     SECTION DATA_4_align_256
     align 256
     SECTION DATA_4_align_128
     align 128
     SECTION DATA_4_align_64
     align 64
     SECTION DATA_4_align_32
     align 32
     SECTION DATA_4_align_16
     align 16
     SECTION DATA_4_align_8
     align 8
     SECTION DATA_4_align_4
     align 4
     SECTION DATA_4_align_2
     align 2
     SECTION BSS_4
     SECTION BANK_04_END

     SECTION BANK_05
     org $250000 + CRT_ORG_BANK_05
     SECTION CODE_5
     SECTION RODATA_5
     SECTION RODATA_5_align_256
     align 256
     SECTION RODATA_5_align_128
     align 128
     SECTION RODATA_5_align_64
     align 64
     SECTION RODATA_5_align_32
     align 32
     SECTION RODATA_5_align_16
     align 16
     SECTION RODATA_5_align_8
     align 8
     SECTION RODATA_5_align_4
     align 4
     SECTION RODATA_5_align_2
     align 2
     SECTION DATA_5
     SECTION DATA_5_align_256
     align 256
     SECTION DATA_5_align_128
     align 128
     SECTION DATA_5_align_64
     align 64
     SECTION DATA_5_align_32
     align 32
     SECTION DATA_5_align_16
     align 16
     SECTION DATA_5_align_8
     align 8
     SECTION DATA_5_align_4
     align 4
     SECTION DATA_5_align_2
     align 2
     SECTION BSS_5
     SECTION BANK_05_END

     SECTION BANK_06
     org $260000 + CRT_ORG_BANK_06
     SECTION CODE_6
     SECTION RODATA_6
     SECTION RODATA_6_align_256
     align 256
     SECTION RODATA_6_align_128
     align 128
     SECTION RODATA_6_align_64
     align 64
     SECTION RODATA_6_align_32
     align 32
     SECTION RODATA_6_align_16
     align 16
     SECTION RODATA_6_align_8
     align 8
     SECTION RODATA_6_align_4
     align 4
     SECTION RODATA_6_align_2
     align 2
     SECTION DATA_6
     SECTION DATA_6_align_256
     align 256
     SECTION DATA_6_align_128
     align 128
     SECTION DATA_6_align_64
     align 64
     SECTION DATA_6_align_32
     align 32
     SECTION DATA_6_align_16
     align 16
     SECTION DATA_6_align_8
     align 8
     SECTION DATA_6_align_4
     align 4
     SECTION DATA_6_align_2
     align 2
     SECTION BSS_6
     SECTION BANK_06_END

     SECTION BANK_07
     org $270000 + CRT_ORG_BANK_07
     SECTION CODE_7
     SECTION RODATA_7
     SECTION RODATA_7_align_256
     align 256
     SECTION RODATA_7_align_128
     align 128
     SECTION RODATA_7_align_64
     align 64
     SECTION RODATA_7_align_32
     align 32
     SECTION RODATA_7_align_16
     align 16
     SECTION RODATA_7_align_8
     align 8
     SECTION RODATA_7_align_4
     align 4
     SECTION RODATA_7_align_2
     align 2
     SECTION DATA_7
     SECTION DATA_7_align_256
     align 256
     SECTION DATA_7_align_128
     align 128
     SECTION DATA_7_align_64
     align 64
     SECTION DATA_7_align_32
     align 32
     SECTION DATA_7_align_16
     align 16
     SECTION DATA_7_align_8
     align 8
     SECTION DATA_7_align_4
     align 4
     SECTION DATA_7_align_2
     align 2
     SECTION BSS_7
     SECTION BANK_07_END

     SECTION BANK_08
     org $280000 + CRT_ORG_BANK_08
     SECTION CODE_8
     SECTION RODATA_8
     SECTION RODATA_8_align_256
     align 256
     SECTION RODATA_8_align_128
     align 128
     SECTION RODATA_8_align_64
     align 64
     SECTION RODATA_8_align_32
     align 32
     SECTION RODATA_8_align_16
     align 16
     SECTION RODATA_8_align_8
     align 8
     SECTION RODATA_8_align_4
     align 4
     SECTION RODATA_8_align_2
     align 2
     SECTION DATA_8
     SECTION DATA_8_align_256
     align 256
     SECTION DATA_8_align_128
     align 128
     SECTION DATA_8_align_64
     align 64
     SECTION DATA_8_align_32
     align 32
     SECTION DATA_8_align_16
     align 16
     SECTION DATA_8_align_8
     align 8
     SECTION DATA_8_align_4
     align 4
     SECTION DATA_8_align_2
     align 2
     SECTION BSS_8
     SECTION BANK_08_END

     SECTION BANK_09
     org $290000 + CRT_ORG_BANK_09
     SECTION CODE_9
     SECTION RODATA_9
     SECTION RODATA_9_align_256
     align 256
     SECTION RODATA_9_align_128
     align 128
     SECTION RODATA_9_align_64
     align 64
     SECTION RODATA_9_align_32
     align 32
     SECTION RODATA_9_align_16
     align 16
     SECTION RODATA_9_align_8
     align 8
     SECTION RODATA_9_align_4
     align 4
     SECTION RODATA_9_align_2
     align 2
     SECTION DATA_9
     SECTION DATA_9_align_256
     align 256
     SECTION DATA_9_align_128
     align 128
     SECTION DATA_9_align_64
     align 64
     SECTION DATA_9_align_32
     align 32
     SECTION DATA_9_align_16
     align 16
     SECTION DATA_9_align_8
     align 8
     SECTION DATA_9_align_4
     align 4
     SECTION DATA_9_align_2
     align 2
     SECTION BSS_9
     SECTION BANK_09_END

     SECTION BANK_0A
     org $2a0000 + CRT_ORG_BANK_0A
     SECTION CODE_10
     SECTION RODATA_10
     SECTION RODATA_10_align_256
     align 256
     SECTION RODATA_10_align_128
     align 128
     SECTION RODATA_10_align_64
     align 64
     SECTION RODATA_10_align_32
     align 32
     SECTION RODATA_10_align_16
     align 16
     SECTION RODATA_10_align_8
     align 8
     SECTION RODATA_10_align_4
     align 4
     SECTION RODATA_10_align_2
     align 2
     SECTION DATA_10
     SECTION DATA_10_align_256
     align 256
     SECTION DATA_10_align_128
     align 128
     SECTION DATA_10_align_64
     align 64
     SECTION DATA_10_align_32
     align 32
     SECTION DATA_10_align_16
     align 16
     SECTION DATA_10_align_8
     align 8
     SECTION DATA_10_align_4
     align 4
     SECTION DATA_10_align_2
     align 2
     SECTION BSS_10
     SECTION BANK_0A_END

     SECTION BANK_0B
     org $2b0000 + CRT_ORG_BANK_0B
     SECTION CODE_11
     SECTION RODATA_11
     SECTION RODATA_11_align_256
     align 256
     SECTION RODATA_11_align_128
     align 128
     SECTION RODATA_11_align_64
     align 64
     SECTION RODATA_11_align_32
     align 32
     SECTION RODATA_11_align_16
     align 16
     SECTION RODATA_11_align_8
     align 8
     SECTION RODATA_11_align_4
     align 4
     SECTION RODATA_11_align_2
     align 2
     SECTION DATA_11
     SECTION DATA_11_align_256
     align 256
     SECTION DATA_11_align_128
     align 128
     SECTION DATA_11_align_64
     align 64
     SECTION DATA_11_align_32
     align 32
     SECTION DATA_11_align_16
     align 16
     SECTION DATA_11_align_8
     align 8
     SECTION DATA_11_align_4
     align 4
     SECTION DATA_11_align_2
     align 2
     SECTION BSS_11
     SECTION BANK_0B_END

     SECTION BANK_0C
     org $2c0000 + CRT_ORG_BANK_0C
     SECTION CODE_12
     SECTION RODATA_12
     SECTION RODATA_12_align_256
     align 256
     SECTION RODATA_12_align_128
     align 128
     SECTION RODATA_12_align_64
     align 64
     SECTION RODATA_12_align_32
     align 32
     SECTION RODATA_12_align_16
     align 16
     SECTION RODATA_12_align_8
     align 8
     SECTION RODATA_12_align_4
     align 4
     SECTION RODATA_12_align_2
     align 2
     SECTION DATA_12
     SECTION DATA_12_align_256
     align 256
     SECTION DATA_12_align_128
     align 128
     SECTION DATA_12_align_64
     align 64
     SECTION DATA_12_align_32
     align 32
     SECTION DATA_12_align_16
     align 16
     SECTION DATA_12_align_8
     align 8
     SECTION DATA_12_align_4
     align 4
     SECTION DATA_12_align_2
     align 2
     SECTION BSS_12
     SECTION BANK_0C_END

     SECTION BANK_0D
     org $2d0000 + CRT_ORG_BANK_0D
     SECTION CODE_13
     SECTION RODATA_13
     SECTION RODATA_13_align_256
     align 256
     SECTION RODATA_13_align_128
     align 128
     SECTION RODATA_13_align_64
     align 64
     SECTION RODATA_13_align_32
     align 32
     SECTION RODATA_13_align_16
     align 16
     SECTION RODATA_13_align_8
     align 8
     SECTION RODATA_13_align_4
     align 4
     SECTION RODATA_13_align_2
     align 2
     SECTION DATA_13
     SECTION DATA_13_align_256
     align 256
     SECTION DATA_13_align_128
     align 128
     SECTION DATA_13_align_64
     align 64
     SECTION DATA_13_align_32
     align 32
     SECTION DATA_13_align_16
     align 16
     SECTION DATA_13_align_8
     align 8
     SECTION DATA_13_align_4
     align 4
     SECTION DATA_13_align_2
     align 2
     SECTION BSS_13
     SECTION BANK_0D_END

     SECTION BANK_0E
     org $2e0000 + CRT_ORG_BANK_0E
     SECTION CODE_14
     SECTION RODATA_14
     SECTION RODATA_14_align_256
     align 256
     SECTION RODATA_14_align_128
     align 128
     SECTION RODATA_14_align_64
     align 64
     SECTION RODATA_14_align_32
     align 32
     SECTION RODATA_14_align_16
     align 16
     SECTION RODATA_14_align_8
     align 8
     SECTION RODATA_14_align_4
     align 4
     SECTION RODATA_14_align_2
     align 2
     SECTION DATA_14
     SECTION DATA_14_align_256
     align 256
     SECTION DATA_14_align_128
     align 128
     SECTION DATA_14_align_64
     align 64
     SECTION DATA_14_align_32
     align 32
     SECTION DATA_14_align_16
     align 16
     SECTION DATA_14_align_8
     align 8
     SECTION DATA_14_align_4
     align 4
     SECTION DATA_14_align_2
     align 2
     SECTION BSS_14
     SECTION BANK_0E_END

     SECTION BANK_0F
     org $2f0000 + CRT_ORG_BANK_0F
     SECTION CODE_15
     SECTION RODATA_15
     SECTION RODATA_15_align_256
     align 256
     SECTION RODATA_15_align_128
     align 128
     SECTION RODATA_15_align_64
     align 64
     SECTION RODATA_15_align_32
     align 32
     SECTION RODATA_15_align_16
     align 16
     SECTION RODATA_15_align_8
     align 8
     SECTION RODATA_15_align_4
     align 4
     SECTION RODATA_15_align_2
     align 2
     SECTION DATA_15
     SECTION DATA_15_align_256
     align 256
     SECTION DATA_15_align_128
     align 128
     SECTION DATA_15_align_64
     align 64
     SECTION DATA_15_align_32
     align 32
     SECTION DATA_15_align_16
     align 16
     SECTION DATA_15_align_8
     align 8
     SECTION DATA_15_align_4
     align 4
     SECTION DATA_15_align_2
     align 2
     SECTION BSS_15
     SECTION BANK_0F_END

     SECTION BANK_10
     org $300000 + CRT_ORG_BANK_10
     SECTION CODE_16
     SECTION RODATA_16
     SECTION RODATA_16_align_256
     align 256
     SECTION RODATA_16_align_128
     align 128
     SECTION RODATA_16_align_64
     align 64
     SECTION RODATA_16_align_32
     align 32
     SECTION RODATA_16_align_16
     align 16
     SECTION RODATA_16_align_8
     align 8
     SECTION RODATA_16_align_4
     align 4
     SECTION RODATA_16_align_2
     align 2
     SECTION DATA_16
     SECTION DATA_16_align_256
     align 256
     SECTION DATA_16_align_128
     align 128
     SECTION DATA_16_align_64
     align 64
     SECTION DATA_16_align_32
     align 32
     SECTION DATA_16_align_16
     align 16
     SECTION DATA_16_align_8
     align 8
     SECTION DATA_16_align_4
     align 4
     SECTION DATA_16_align_2
     align 2
     SECTION BSS_16
     SECTION BANK_10_END

     SECTION BANK_11
     org $310000 + CRT_ORG_BANK_11
     SECTION CODE_17
     SECTION RODATA_17
     SECTION RODATA_17_align_256
     align 256
     SECTION RODATA_17_align_128
     align 128
     SECTION RODATA_17_align_64
     align 64
     SECTION RODATA_17_align_32
     align 32
     SECTION RODATA_17_align_16
     align 16
     SECTION RODATA_17_align_8
     align 8
     SECTION RODATA_17_align_4
     align 4
     SECTION RODATA_17_align_2
     align 2
     SECTION DATA_17
     SECTION DATA_17_align_256
     align 256
     SECTION DATA_17_align_128
     align 128
     SECTION DATA_17_align_64
     align 64
     SECTION DATA_17_align_32
     align 32
     SECTION DATA_17_align_16
     align 16
     SECTION DATA_17_align_8
     align 8
     SECTION DATA_17_align_4
     align 4
     SECTION DATA_17_align_2
     align 2
     SECTION BSS_17
     SECTION BANK_11_END

     SECTION BANK_12
     org $320000 + CRT_ORG_BANK_12
     SECTION CODE_18
     SECTION RODATA_18
     SECTION RODATA_18_align_256
     align 256
     SECTION RODATA_18_align_128
     align 128
     SECTION RODATA_18_align_64
     align 64
     SECTION RODATA_18_align_32
     align 32
     SECTION RODATA_18_align_16
     align 16
     SECTION RODATA_18_align_8
     align 8
     SECTION RODATA_18_align_4
     align 4
     SECTION RODATA_18_align_2
     align 2
     SECTION DATA_18
     SECTION DATA_18_align_256
     align 256
     SECTION DATA_18_align_128
     align 128
     SECTION DATA_18_align_64
     align 64
     SECTION DATA_18_align_32
     align 32
     SECTION DATA_18_align_16
     align 16
     SECTION DATA_18_align_8
     align 8
     SECTION DATA_18_align_4
     align 4
     SECTION DATA_18_align_2
     align 2
     SECTION BSS_18
     SECTION BANK_12_END

     SECTION BANK_13
     org $330000 + CRT_ORG_BANK_13
     SECTION CODE_19
     SECTION RODATA_19
     SECTION RODATA_19_align_256
     align 256
     SECTION RODATA_19_align_128
     align 128
     SECTION RODATA_19_align_64
     align 64
     SECTION RODATA_19_align_32
     align 32
     SECTION RODATA_19_align_16
     align 16
     SECTION RODATA_19_align_8
     align 8
     SECTION RODATA_19_align_4
     align 4
     SECTION RODATA_19_align_2
     align 2
     SECTION DATA_19
     SECTION DATA_19_align_256
     align 256
     SECTION DATA_19_align_128
     align 128
     SECTION DATA_19_align_64
     align 64
     SECTION DATA_19_align_32
     align 32
     SECTION DATA_19_align_16
     align 16
     SECTION DATA_19_align_8
     align 8
     SECTION DATA_19_align_4
     align 4
     SECTION DATA_19_align_2
     align 2
     SECTION BSS_19
     SECTION BANK_13_END

     SECTION BANK_14
     org $340000 + CRT_ORG_BANK_14
     SECTION CODE_20
     SECTION RODATA_20
     SECTION RODATA_20_align_256
     align 256
     SECTION RODATA_20_align_128
     align 128
     SECTION RODATA_20_align_64
     align 64
     SECTION RODATA_20_align_32
     align 32
     SECTION RODATA_20_align_16
     align 16
     SECTION RODATA_20_align_8
     align 8
     SECTION RODATA_20_align_4
     align 4
     SECTION RODATA_20_align_2
     align 2
     SECTION DATA_20
     SECTION DATA_20_align_256
     align 256
     SECTION DATA_20_align_128
     align 128
     SECTION DATA_20_align_64
     align 64
     SECTION DATA_20_align_32
     align 32
     SECTION DATA_20_align_16
     align 16
     SECTION DATA_20_align_8
     align 8
     SECTION DATA_20_align_4
     align 4
     SECTION DATA_20_align_2
     align 2
     SECTION BSS_20
     SECTION BANK_14_END

     SECTION BANK_15
     org $350000 + CRT_ORG_BANK_15
     SECTION CODE_21
     SECTION RODATA_21
     SECTION RODATA_21_align_256
     align 256
     SECTION RODATA_21_align_128
     align 128
     SECTION RODATA_21_align_64
     align 64
     SECTION RODATA_21_align_32
     align 32
     SECTION RODATA_21_align_16
     align 16
     SECTION RODATA_21_align_8
     align 8
     SECTION RODATA_21_align_4
     align 4
     SECTION RODATA_21_align_2
     align 2
     SECTION DATA_21
     SECTION DATA_21_align_256
     align 256
     SECTION DATA_21_align_128
     align 128
     SECTION DATA_21_align_64
     align 64
     SECTION DATA_21_align_32
     align 32
     SECTION DATA_21_align_16
     align 16
     SECTION DATA_21_align_8
     align 8
     SECTION DATA_21_align_4
     align 4
     SECTION DATA_21_align_2
     align 2
     SECTION BSS_21
     SECTION BANK_15_END

     SECTION BANK_16
     org $360000 + CRT_ORG_BANK_16
     SECTION CODE_22
     SECTION RODATA_22
     SECTION RODATA_22_align_256
     align 256
     SECTION RODATA_22_align_128
     align 128
     SECTION RODATA_22_align_64
     align 64
     SECTION RODATA_22_align_32
     align 32
     SECTION RODATA_22_align_16
     align 16
     SECTION RODATA_22_align_8
     align 8
     SECTION RODATA_22_align_4
     align 4
     SECTION RODATA_22_align_2
     align 2
     SECTION DATA_22
     SECTION DATA_22_align_256
     align 256
     SECTION DATA_22_align_128
     align 128
     SECTION DATA_22_align_64
     align 64
     SECTION DATA_22_align_32
     align 32
     SECTION DATA_22_align_16
     align 16
     SECTION DATA_22_align_8
     align 8
     SECTION DATA_22_align_4
     align 4
     SECTION DATA_22_align_2
     align 2
     SECTION BSS_22
     SECTION BANK_16_END

     SECTION BANK_17
     org $370000 + CRT_ORG_BANK_17
     SECTION CODE_23
     SECTION RODATA_23
     SECTION RODATA_23_align_256
     align 256
     SECTION RODATA_23_align_128
     align 128
     SECTION RODATA_23_align_64
     align 64
     SECTION RODATA_23_align_32
     align 32
     SECTION RODATA_23_align_16
     align 16
     SECTION RODATA_23_align_8
     align 8
     SECTION RODATA_23_align_4
     align 4
     SECTION RODATA_23_align_2
     align 2
     SECTION DATA_23
     SECTION DATA_23_align_256
     align 256
     SECTION DATA_23_align_128
     align 128
     SECTION DATA_23_align_64
     align 64
     SECTION DATA_23_align_32
     align 32
     SECTION DATA_23_align_16
     align 16
     SECTION DATA_23_align_8
     align 8
     SECTION DATA_23_align_4
     align 4
     SECTION DATA_23_align_2
     align 2
     SECTION BSS_23
     SECTION BANK_17_END

     SECTION BANK_18
     org $380000 + CRT_ORG_BANK_18
     SECTION CODE_24
     SECTION RODATA_24
     SECTION RODATA_24_align_256
     align 256
     SECTION RODATA_24_align_128
     align 128
     SECTION RODATA_24_align_64
     align 64
     SECTION RODATA_24_align_32
     align 32
     SECTION RODATA_24_align_16
     align 16
     SECTION RODATA_24_align_8
     align 8
     SECTION RODATA_24_align_4
     align 4
     SECTION RODATA_24_align_2
     align 2
     SECTION DATA_24
     SECTION DATA_24_align_256
     align 256
     SECTION DATA_24_align_128
     align 128
     SECTION DATA_24_align_64
     align 64
     SECTION DATA_24_align_32
     align 32
     SECTION DATA_24_align_16
     align 16
     SECTION DATA_24_align_8
     align 8
     SECTION DATA_24_align_4
     align 4
     SECTION DATA_24_align_2
     align 2
     SECTION BSS_24
     SECTION BANK_18_END

     SECTION BANK_19
     org $390000 + CRT_ORG_BANK_19
     SECTION CODE_25
     SECTION RODATA_25
     SECTION RODATA_25_align_256
     align 256
     SECTION RODATA_25_align_128
     align 128
     SECTION RODATA_25_align_64
     align 64
     SECTION RODATA_25_align_32
     align 32
     SECTION RODATA_25_align_16
     align 16
     SECTION RODATA_25_align_8
     align 8
     SECTION RODATA_25_align_4
     align 4
     SECTION RODATA_25_align_2
     align 2
     SECTION DATA_25
     SECTION DATA_25_align_256
     align 256
     SECTION DATA_25_align_128
     align 128
     SECTION DATA_25_align_64
     align 64
     SECTION DATA_25_align_32
     align 32
     SECTION DATA_25_align_16
     align 16
     SECTION DATA_25_align_8
     align 8
     SECTION DATA_25_align_4
     align 4
     SECTION DATA_25_align_2
     align 2
     SECTION BSS_25
     SECTION BANK_19_END

     SECTION BANK_1A
     org $3a0000 + CRT_ORG_BANK_1A
     SECTION CODE_26
     SECTION RODATA_26
     SECTION RODATA_26_align_256
     align 256
     SECTION RODATA_26_align_128
     align 128
     SECTION RODATA_26_align_64
     align 64
     SECTION RODATA_26_align_32
     align 32
     SECTION RODATA_26_align_16
     align 16
     SECTION RODATA_26_align_8
     align 8
     SECTION RODATA_26_align_4
     align 4
     SECTION RODATA_26_align_2
     align 2
     SECTION DATA_26
     SECTION DATA_26_align_256
     align 256
     SECTION DATA_26_align_128
     align 128
     SECTION DATA_26_align_64
     align 64
     SECTION DATA_26_align_32
     align 32
     SECTION DATA_26_align_16
     align 16
     SECTION DATA_26_align_8
     align 8
     SECTION DATA_26_align_4
     align 4
     SECTION DATA_26_align_2
     align 2
     SECTION BSS_26
     SECTION BANK_1A_END

     SECTION BANK_1B
     org $3b0000 + CRT_ORG_BANK_1B
     SECTION CODE_27
     SECTION RODATA_27
     SECTION RODATA_27_align_256
     align 256
     SECTION RODATA_27_align_128
     align 128
     SECTION RODATA_27_align_64
     align 64
     SECTION RODATA_27_align_32
     align 32
     SECTION RODATA_27_align_16
     align 16
     SECTION RODATA_27_align_8
     align 8
     SECTION RODATA_27_align_4
     align 4
     SECTION RODATA_27_align_2
     align 2
     SECTION DATA_27
     SECTION DATA_27_align_256
     align 256
     SECTION DATA_27_align_128
     align 128
     SECTION DATA_27_align_64
     align 64
     SECTION DATA_27_align_32
     align 32
     SECTION DATA_27_align_16
     align 16
     SECTION DATA_27_align_8
     align 8
     SECTION DATA_27_align_4
     align 4
     SECTION DATA_27_align_2
     align 2
     SECTION BSS_27
     SECTION BANK_1B_END

     SECTION BANK_1C
     org $3c0000 + CRT_ORG_BANK_1C
     SECTION CODE_28
     SECTION RODATA_28
     SECTION RODATA_28_align_256
     align 256
     SECTION RODATA_28_align_128
     align 128
     SECTION RODATA_28_align_64
     align 64
     SECTION RODATA_28_align_32
     align 32
     SECTION RODATA_28_align_16
     align 16
     SECTION RODATA_28_align_8
     align 8
     SECTION RODATA_28_align_4
     align 4
     SECTION RODATA_28_align_2
     align 2
     SECTION DATA_28
     SECTION DATA_28_align_256
     align 256
     SECTION DATA_28_align_128
     align 128
     SECTION DATA_28_align_64
     align 64
     SECTION DATA_28_align_32
     align 32
     SECTION DATA_28_align_16
     align 16
     SECTION DATA_28_align_8
     align 8
     SECTION DATA_28_align_4
     align 4
     SECTION DATA_28_align_2
     align 2
     SECTION BSS_28
     SECTION BANK_1C_END

     SECTION BANK_1D
     org $3d0000 + CRT_ORG_BANK_1D
     SECTION CODE_29
     SECTION RODATA_29
     SECTION RODATA_29_align_256
     align 256
     SECTION RODATA_29_align_128
     align 128
     SECTION RODATA_29_align_64
     align 64
     SECTION RODATA_29_align_32
     align 32
     SECTION RODATA_29_align_16
     align 16
     SECTION RODATA_29_align_8
     align 8
     SECTION RODATA_29_align_4
     align 4
     SECTION RODATA_29_align_2
     align 2
     SECTION DATA_29
     SECTION DATA_29_align_256
     align 256
     SECTION DATA_29_align_128
     align 128
     SECTION DATA_29_align_64
     align 64
     SECTION DATA_29_align_32
     align 32
     SECTION DATA_29_align_16
     align 16
     SECTION DATA_29_align_8
     align 8
     SECTION DATA_29_align_4
     align 4
     SECTION DATA_29_align_2
     align 2
     SECTION BSS_29
     SECTION BANK_1D_END

     SECTION BANK_1E
     org $3e0000 + CRT_ORG_BANK_1E
     SECTION CODE_30
     SECTION RODATA_30
     SECTION RODATA_30_align_256
     align 256
     SECTION RODATA_30_align_128
     align 128
     SECTION RODATA_30_align_64
     align 64
     SECTION RODATA_30_align_32
     align 32
     SECTION RODATA_30_align_16
     align 16
     SECTION RODATA_30_align_8
     align 8
     SECTION RODATA_30_align_4
     align 4
     SECTION RODATA_30_align_2
     align 2
     SECTION DATA_30
     SECTION DATA_30_align_256
     align 256
     SECTION DATA_30_align_128
     align 128
     SECTION DATA_30_align_64
     align 64
     SECTION DATA_30_align_32
     align 32
     SECTION DATA_30_align_16
     align 16
     SECTION DATA_30_align_8
     align 8
     SECTION DATA_30_align_4
     align 4
     SECTION DATA_30_align_2
     align 2
     SECTION BSS_30
     SECTION BANK_1E_END

     SECTION BANK_1F
     org $3f0000 + CRT_ORG_BANK_1F
     SECTION CODE_31
     SECTION RODATA_31
     SECTION RODATA_31_align_256
     align 256
     SECTION RODATA_31_align_128
     align 128
     SECTION RODATA_31_align_64
     align 64
     SECTION RODATA_31_align_32
     align 32
     SECTION RODATA_31_align_16
     align 16
     SECTION RODATA_31_align_8
     align 8
     SECTION RODATA_31_align_4
     align 4
     SECTION RODATA_31_align_2
     align 2
     SECTION DATA_31
     SECTION DATA_31_align_256
     align 256
     SECTION DATA_31_align_128
     align 128
     SECTION DATA_31_align_64
     align 64
     SECTION DATA_31_align_32
     align 32
     SECTION DATA_31_align_16
     align 16
     SECTION DATA_31_align_8
     align 8
     SECTION DATA_31_align_4
     align 4
     SECTION DATA_31_align_2
     align 2
     SECTION BSS_31
     SECTION BANK_1F_END

