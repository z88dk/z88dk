ld a,1
binary "binary_06.bin" ; includes local file
ld a,2
binary <binary_06.bin> ; includes library file
ld a,3
