section code
org 0x1000
defb 1, 2, 3
org 0x1000      ; go back, error
defb 4, 5, 6
