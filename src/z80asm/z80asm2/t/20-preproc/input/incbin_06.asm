ld a,1
incbin "incbin_06.bin" ; includes local file
ld a,2
incbin <incbin_06.bin> ; includes library file
ld a,3
