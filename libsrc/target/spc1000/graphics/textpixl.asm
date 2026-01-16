;
;
;	Support char table (pseudo graph symbols) for the SPC-1000
;
;       .. X. .X XX
;       .. .. .. ..
;
;       .. X. .X XX
;       X. X. X. X.
;
;       .. X. .X XX
;       .X .X .X .X
;
;       .. X. .X XX
;       XX XX XX XX


    SECTION rodata_clib
    PUBLIC  textpixl

textpixl:
    defb    240, 248, 244, 252
    defb    242, 250, 246, 254
    defb    241, 249, 245, 253
    defb    243, 242, 247, 255

