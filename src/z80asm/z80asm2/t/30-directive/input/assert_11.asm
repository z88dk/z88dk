#define X
ld a, 1
#assert ; no arguments
ld a, 2
#assert asmpc ; not constant
ld a, 3
#assert X extra
ld a, 4
#assert X , extra
ld a, 5
#assert X , "hello" extra
ld a, 6
#assert X ; no error
ld a, 7
#assert !X ; error
ld a, 8
#assert X, "user error" ; no error
ld a, 9
#assert !X, "user error" ; error
ld a, 10
