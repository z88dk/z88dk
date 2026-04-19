ld a, 1
error 25 ; expects string
ld a, 2
error "hello" extra ; expects eol
ld a, 3
error ; no arguments, error
ld a, 4
error "user error" ; error
ld a, 5
