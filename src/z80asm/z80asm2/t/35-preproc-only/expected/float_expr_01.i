# 1 "t/35-preproc-only/input/float_expr_01.asm"
defm"--------"
defm"1 = 1"
DEFB 0
# 3
DEFB 0
# 3
DEFB 0
# 3
DEFB 0
# 3
DEFB 0
# 3
DEFB $81
defm"--------"
DEFB 0
# 5
DEFB 0
# 5
DEFB 0
# 5
DEFB 0
# 5
DEFB 0
# 5
DEFB $81
defm"--------"
defm"pi = 3.14159265358979"
DEFB $21
# 8
DEFB $A2
# 8
DEFB $DA
# 8
DEFB $0F
# 8
DEFB $49
# 8
DEFB $82
defm"--------"
DEFB $21
# 10
DEFB $A2
# 10
DEFB $DA
# 10
DEFB $0F
# 10
DEFB $49
# 10
DEFB $82
defm"--------"
defm"e = 2.71828182845905"
DEFB $A3
# 13
DEFB $58
# 13
DEFB $54
# 13
DEFB $F8
# 13
DEFB $2D
# 13
DEFB $82
defm"--------"
DEFB $A3
# 15
DEFB $58
# 15
DEFB $54
# 15
DEFB $F8
# 15
DEFB $2D
# 15
DEFB $82
defm"--------"
defm"1+.5 = 1.5"
DEFB 0
# 18
DEFB 0
# 18
DEFB 0
# 18
DEFB 0
# 18
DEFB $40
# 18
DEFB $81
defm"--------"
DEFB 0
# 20
DEFB 0
# 20
DEFB 0
# 20
DEFB 0
# 20
DEFB $40
# 20
DEFB $81
defm"--------"
defm"1-.5 = 0.5"
DEFB 0
# 23
DEFB 0
# 23
DEFB 0
# 23
DEFB 0
# 23
DEFB 0
# 23
DEFB $80
defm"--------"
DEFB 0
# 25
DEFB 0
# 25
DEFB 0
# 25
DEFB 0
# 25
DEFB 0
# 25
DEFB $80
defm"--------"
defm"1+-.5 = 0.5"
DEFB 0
# 28
DEFB 0
# 28
DEFB 0
# 28
DEFB 0
# 28
DEFB 0
# 28
DEFB $80
defm"--------"
DEFB 0
# 30
DEFB 0
# 30
DEFB 0
# 30
DEFB 0
# 30
DEFB 0
# 30
DEFB $80
defm"--------"
defm"2*4 = 8"
DEFB 0
# 33
DEFB 0
# 33
DEFB 0
# 33
DEFB 0
# 33
DEFB 0
# 33
DEFB $84
defm"--------"
DEFB 0
# 35
DEFB 0
# 35
DEFB 0
# 35
DEFB 0
# 35
DEFB 0
# 35
DEFB $84
defm"--------"
defm"2/4 = 0.5"
DEFB 0
# 38
DEFB 0
# 38
DEFB 0
# 38
DEFB 0
# 38
DEFB 0
# 38
DEFB $80
defm"--------"
DEFB 0
# 40
DEFB 0
# 40
DEFB 0
# 40
DEFB 0
# 40
DEFB 0
# 40
DEFB $80
defm"--------"
defm"2*-4 = -8"
DEFB 0
# 43
DEFB 0
# 43
DEFB 0
# 43
DEFB 0
# 43
DEFB $80
# 43
DEFB $84
defm"--------"
DEFB 0
# 45
DEFB 0
# 45
DEFB 0
# 45
DEFB 0
# 45
DEFB $80
# 45
DEFB $84
defm"--------"
defm"2**8 = 256"
DEFB 0
# 48
DEFB 0
# 48
DEFB 0
# 48
DEFB 0
# 48
DEFB 0
# 48
DEFB $89
defm"--------"
DEFB 0
# 50
DEFB 0
# 50
DEFB 0
# 50
DEFB 0
# 50
DEFB 0
# 50
DEFB $89
defm"--------"
defm"4**3**2 = 262144"
DEFB 0
# 53
DEFB 0
# 53
DEFB 0
# 53
DEFB 0
# 53
DEFB 0
# 53
DEFB $93
defm"--------"
DEFB 0
# 55
DEFB 0
# 55
DEFB 0
# 55
DEFB 0
# 55
DEFB 0
# 55
DEFB $93
defm"--------"
defm"(4**3)**2 = 4096"
DEFB 0
# 58
DEFB 0
# 58
DEFB 0
# 58
DEFB 0
# 58
DEFB 0
# 58
DEFB $8D
defm"--------"
DEFB 0
# 60
DEFB 0
# 60
DEFB 0
# 60
DEFB 0
# 60
DEFB 0
# 60
DEFB $8D
defm"--------"
defm"4**(0.5) = 2"
DEFB 0
# 63
DEFB 0
# 63
DEFB 0
# 63
DEFB 0
# 63
DEFB 0
# 63
DEFB $82
defm"--------"
DEFB 0
# 65
DEFB 0
# 65
DEFB 0
# 65
DEFB 0
# 65
DEFB 0
# 65
DEFB $82
defm"--------"
defm"+4 = 4"
DEFB 0
# 68
DEFB 0
# 68
DEFB 0
# 68
DEFB 0
# 68
DEFB 0
# 68
DEFB $83
defm"--------"
DEFB 0
# 70
DEFB 0
# 70
DEFB 0
# 70
DEFB 0
# 70
DEFB 0
# 70
DEFB $83
defm"--------"
defm"+ +4 = 4"
DEFB 0
# 73
DEFB 0
# 73
DEFB 0
# 73
DEFB 0
# 73
DEFB 0
# 73
DEFB $83
defm"--------"
DEFB 0
# 75
DEFB 0
# 75
DEFB 0
# 75
DEFB 0
# 75
DEFB 0
# 75
DEFB $83
defm"--------"
defm"+ + -4 = -4"
DEFB 0
# 78
DEFB 0
# 78
DEFB 0
# 78
DEFB 0
# 78
DEFB $80
# 78
DEFB $83
defm"--------"
DEFB 0
# 80
DEFB 0
# 80
DEFB 0
# 80
DEFB 0
# 80
DEFB $80
# 80
DEFB $83
defm"--------"
defm"+ + - +4 = -4"
DEFB 0
# 83
DEFB 0
# 83
DEFB 0
# 83
DEFB 0
# 83
DEFB $80
# 83
DEFB $83
defm"--------"
DEFB 0
# 85
DEFB 0
# 85
DEFB 0
# 85
DEFB 0
# 85
DEFB $80
# 85
DEFB $83
defm"--------"
defm"2+3*4 = 14"
DEFB 0
# 88
DEFB 0
# 88
DEFB 0
# 88
DEFB 0
# 88
DEFB $60
# 88
DEFB $84
defm"--------"
DEFB 0
# 90
DEFB 0
# 90
DEFB 0
# 90
DEFB 0
# 90
DEFB $60
# 90
DEFB $84
defm"--------"
defm"(2+3)*4 = 20"
DEFB 0
# 93
DEFB 0
# 93
DEFB 0
# 93
DEFB 0
# 93
DEFB $20
# 93
DEFB $85
defm"--------"
DEFB 0
# 95
DEFB 0
# 95
DEFB 0
# 95
DEFB 0
# 95
DEFB $20
# 95
DEFB $85
defm"--------"
defm"2*3+4 = 10"
DEFB 0
# 98
DEFB 0
# 98
DEFB 0
# 98
DEFB 0
# 98
DEFB $20
# 98
DEFB $84
defm"--------"
DEFB 0
# 100
DEFB 0
# 100
DEFB 0
# 100
DEFB 0
# 100
DEFB $20
# 100
DEFB $84
defm"--------"
defm"2*(3+4) = 14"
DEFB 0
# 103
DEFB 0
# 103
DEFB 0
# 103
DEFB 0
# 103
DEFB $60
# 103
DEFB $84
defm"--------"
DEFB 0
# 105
DEFB 0
# 105
DEFB 0
# 105
DEFB 0
# 105
DEFB $60
# 105
DEFB $84
defm"--------"
defm"sin(0.5) = 0.479425538604203"
DEFB $58
# 108
DEFB $A2
# 108
DEFB $43
# 108
DEFB $77
# 108
DEFB $75
# 108
DEFB $7F
defm"--------"
DEFB $58
# 110
DEFB $A2
# 110
DEFB $43
# 110
DEFB $77
# 110
DEFB $75
# 110
DEFB $7F
defm"--------"
defm"asin(sin(0.5)) = 0.5"
DEFB 0
# 113
DEFB 0
# 113
DEFB 0
# 113
DEFB 0
# 113
DEFB 0
# 113
DEFB $80
defm"--------"
DEFB 0
# 115
DEFB 0
# 115
DEFB 0
# 115
DEFB 0
# 115
DEFB 0
# 115
DEFB $80
defm"--------"
defm"cos(0.5) = 0.877582561890373"
DEFB $DC
# 118
DEFB $32
# 118
DEFB $40
# 118
DEFB $A9
# 118
DEFB $60
# 118
DEFB $80
defm"--------"
DEFB $DC
# 120
DEFB $32
# 120
DEFB $40
# 120
DEFB $A9
# 120
DEFB $60
# 120
DEFB $80
defm"--------"
defm"acos(cos(0.5)) = 0.5"
DEFB 0
# 123
DEFB 0
# 123
DEFB 0
# 123
DEFB 0
# 123
DEFB $80
# 123
DEFB $7F
defm"--------"
DEFB 0
# 125
DEFB 0
# 125
DEFB 0
# 125
DEFB 0
# 125
DEFB 0
# 125
DEFB $80
defm"--------"
defm"tan(0.5) = 0.54630248984379"
DEFB $9A
# 128
DEFB $DF
# 128
DEFB $7A
# 128
DEFB $DA
# 128
DEFB $0B
# 128
DEFB $80
defm"--------"
DEFB $9A
# 130
DEFB $DF
# 130
DEFB $7A
# 130
DEFB $DA
# 130
DEFB $0B
# 130
DEFB $80
defm"--------"
defm"atan(tan(0.5)) = 0.5"
DEFB 0
# 133
DEFB 0
# 133
DEFB 0
# 133
DEFB 0
# 133
DEFB 0
# 133
DEFB $80
defm"--------"
DEFB 0
# 135
DEFB 0
# 135
DEFB 0
# 135
DEFB 0
# 135
DEFB 0
# 135
DEFB $80
defm"--------"
defm"sinh(0.5) = 0.521095305493747"
DEFB $32
# 138
DEFB $7F
# 138
DEFB $80
# 138
DEFB $66
# 138
DEFB 5
# 138
DEFB $80
defm"--------"
DEFB $32
# 140
DEFB $7F
# 140
DEFB $80
# 140
DEFB $66
# 140
DEFB 5
# 140
DEFB $80
defm"--------"
defm"asinh(sinh(0.5)) = 0.5"
DEFB 0
# 143
DEFB 0
# 143
DEFB 0
# 143
DEFB 0
# 143
DEFB 0
# 143
DEFB $80
defm"--------"
DEFB 0
# 145
DEFB 0
# 145
DEFB 0
# 145
DEFB 0
# 145
DEFB 0
# 145
DEFB $80
defm"--------"
defm"cosh(0.5) = 1.12762596520638"
DEFB $57
# 148
DEFB $31
# 148
DEFB $0C
# 148
DEFB $56
# 148
DEFB $10
# 148
DEFB $81
defm"--------"
DEFB $57
# 150
DEFB $31
# 150
DEFB $0C
# 150
DEFB $56
# 150
DEFB $10
# 150
DEFB $81
defm"--------"
defm"acosh(cosh(0.5)) = 0.5"
DEFB 0
# 153
DEFB 0
# 153
DEFB 0
# 153
DEFB 0
# 153
DEFB $80
# 153
DEFB $7F
defm"--------"
DEFB 0
# 155
DEFB 0
# 155
DEFB 0
# 155
DEFB 0
# 155
DEFB 0
# 155
DEFB $80
defm"--------"
defm"tanh(0.5) = 0.46211715726001"
DEFB $B4
# 158
DEFB $BA
# 158
DEFB $9E
# 158
DEFB $9A
# 158
DEFB $6C
# 158
DEFB $7F
defm"--------"
DEFB $B4
# 160
DEFB $BA
# 160
DEFB $9E
# 160
DEFB $9A
# 160
DEFB $6C
# 160
DEFB $7F
defm"--------"
defm"atanh(tanh(0.5)) = 0.5"
DEFB 0
# 163
DEFB 0
# 163
DEFB 0
# 163
DEFB 0
# 163
DEFB 0
# 163
DEFB $80
defm"--------"
DEFB 0
# 165
DEFB 0
# 165
DEFB 0
# 165
DEFB 0
# 165
DEFB 0
# 165
DEFB $80
defm"--------"
defm"atan2(0.5,0.5) = 0.785398163397448"
DEFB $21
# 168
DEFB $A2
# 168
DEFB $DA
# 168
DEFB $0F
# 168
DEFB $49
# 168
DEFB $80
defm"--------"
DEFB $21
# 170
DEFB $A2
# 170
DEFB $DA
# 170
DEFB $0F
# 170
DEFB $49
# 170
DEFB $80
defm"--------"
defm"log(2.7) = 0.993251773010283"
DEFB $C6
# 173
DEFB $89
# 173
DEFB $BF
# 173
DEFB $45
# 173
DEFB $7E
# 173
DEFB $80
defm"--------"
DEFB $C6
# 175
DEFB $89
# 175
DEFB $BF
# 175
DEFB $45
# 175
DEFB $7E
# 175
DEFB $80
defm"--------"
defm"log2(2.5) = 1.32192809488736"
DEFB $9A
# 178
DEFB $97
# 178
DEFB $F0
# 178
DEFB $34
# 178
DEFB $29
# 178
DEFB $81
defm"--------"
DEFB $9A
# 180
DEFB $97
# 180
DEFB $F0
# 180
DEFB $34
# 180
DEFB $29
# 180
DEFB $81
defm"--------"
defm"log10(15) = 1.17609125905568"
DEFB $61
# 183
DEFB $8B
# 183
DEFB $28
# 183
DEFB $8A
# 183
DEFB $16
# 183
DEFB $81
defm"--------"
DEFB $61
# 185
DEFB $8B
# 185
DEFB $28
# 185
DEFB $8A
# 185
DEFB $16
# 185
DEFB $81
defm"--------"
defm"exp(2) = 7.38905609893065"
DEFB $A7
# 188
DEFB $C6
# 188
DEFB $25
# 188
DEFB $73
# 188
DEFB $6C
# 188
DEFB $83
defm"--------"
DEFB $A7
# 190
DEFB $C6
# 190
DEFB $25
# 190
DEFB $73
# 190
DEFB $6C
# 190
DEFB $83
defm"--------"
defm"exp2(2) = 4"
DEFB 0
# 193
DEFB 0
# 193
DEFB 0
# 193
DEFB 0
# 193
DEFB 0
# 193
DEFB $83
defm"--------"
DEFB 0
# 195
DEFB 0
# 195
DEFB 0
# 195
DEFB 0
# 195
DEFB 0
# 195
DEFB $83
defm"--------"
defm"pow(2,4) = 16"
DEFB 0
# 198
DEFB 0
# 198
DEFB 0
# 198
DEFB 0
# 198
DEFB 0
# 198
DEFB $85
defm"--------"
DEFB 0
# 200
DEFB 0
# 200
DEFB 0
# 200
DEFB 0
# 200
DEFB 0
# 200
DEFB $85
defm"--------"
defm"sqrt(4) = 2"
DEFB 0
# 203
DEFB 0
# 203
DEFB 0
# 203
DEFB 0
# 203
DEFB 0
# 203
DEFB $82
defm"--------"
DEFB 0
# 205
DEFB 0
# 205
DEFB 0
# 205
DEFB 0
# 205
DEFB 0
# 205
DEFB $82
defm"--------"
defm"cbrt(8) = 2"
DEFB 0
# 208
DEFB 0
# 208
DEFB 0
# 208
DEFB 0
# 208
DEFB 0
# 208
DEFB $82
defm"--------"
DEFB 0
# 210
DEFB 0
# 210
DEFB 0
# 210
DEFB 0
# 210
DEFB 0
# 210
DEFB $82
defm"--------"
defm"ceil(2.5) = 3"
DEFB 0
# 213
DEFB 0
# 213
DEFB 0
# 213
DEFB 0
# 213
DEFB $40
# 213
DEFB $82
defm"--------"
DEFB 0
# 215
DEFB 0
# 215
DEFB 0
# 215
DEFB 0
# 215
DEFB $40
# 215
DEFB $82
defm"--------"
defm"ceil(-2.5) = -2"
DEFB 0
# 218
DEFB 0
# 218
DEFB 0
# 218
DEFB 0
# 218
DEFB $80
# 218
DEFB $82
defm"--------"
DEFB 0
# 220
DEFB 0
# 220
DEFB 0
# 220
DEFB 0
# 220
DEFB $80
# 220
DEFB $82
defm"--------"
defm"floor(2.5) = 2"
DEFB 0
# 223
DEFB 0
# 223
DEFB 0
# 223
DEFB 0
# 223
DEFB 0
# 223
DEFB $82
defm"--------"
DEFB 0
# 225
DEFB 0
# 225
DEFB 0
# 225
DEFB 0
# 225
DEFB 0
# 225
DEFB $82
defm"--------"
defm"floor(-2.5) = -3"
DEFB 0
# 228
DEFB 0
# 228
DEFB 0
# 228
DEFB 0
# 228
DEFB $C0
# 228
DEFB $82
defm"--------"
DEFB 0
# 230
DEFB 0
# 230
DEFB 0
# 230
DEFB 0
# 230
DEFB $C0
# 230
DEFB $82
defm"--------"
defm"trunc(2.5) = 2"
DEFB 0
# 233
DEFB 0
# 233
DEFB 0
# 233
DEFB 0
# 233
DEFB 0
# 233
DEFB $82
defm"--------"
DEFB 0
# 235
DEFB 0
# 235
DEFB 0
# 235
DEFB 0
# 235
DEFB 0
# 235
DEFB $82
defm"--------"
defm"trunc(-2.5) = -2"
DEFB 0
# 238
DEFB 0
# 238
DEFB 0
# 238
DEFB 0
# 238
DEFB $80
# 238
DEFB $82
defm"--------"
DEFB 0
# 240
DEFB 0
# 240
DEFB 0
# 240
DEFB 0
# 240
DEFB $80
# 240
DEFB $82
defm"--------"
defm"abs(2.5) = 2.5"
DEFB 0
# 243
DEFB 0
# 243
DEFB 0
# 243
DEFB 0
# 243
DEFB $20
# 243
DEFB $82
defm"--------"
DEFB 0
# 245
DEFB 0
# 245
DEFB 0
# 245
DEFB 0
# 245
DEFB $20
# 245
DEFB $82
defm"--------"
defm"abs(-2.5) = 2.5"
DEFB 0
# 248
DEFB 0
# 248
DEFB 0
# 248
DEFB 0
# 248
DEFB $20
# 248
DEFB $82
defm"--------"
DEFB 0
# 250
DEFB 0
# 250
DEFB 0
# 250
DEFB 0
# 250
DEFB $20
# 250
DEFB $82
defm"--------"
defm"hypot(2,3) = 3.60555127546399"
DEFB $0B
# 253
DEFB $23
# 253
DEFB $5A
# 253
DEFB $C1
# 253
DEFB $66
# 253
DEFB $82
defm"--------"
DEFB $0B
# 255
DEFB $23
# 255
DEFB $5A
# 255
DEFB $C1
# 255
DEFB $66
# 255
DEFB $82
defm"--------"
defm"fmod(10,3) = 1"
DEFB 0
# 258
DEFB 0
# 258
DEFB 0
# 258
DEFB 0
# 258
DEFB 0
# 258
DEFB $81
defm"--------"
DEFB 0
# 260
DEFB 0
# 260
DEFB 0
# 260
DEFB 0
# 260
DEFB 0
# 260
DEFB $81
defm"--------"
defm"fmod(10,-3) = 1"
DEFB 0
# 263
DEFB 0
# 263
DEFB 0
# 263
DEFB 0
# 263
DEFB 0
# 263
DEFB $81
defm"--------"
DEFB 0
# 265
DEFB 0
# 265
DEFB 0
# 265
DEFB 0
# 265
DEFB 0
# 265
DEFB $81
defm"--------"
defm"fmod(-10,3) = -1"
DEFB 0
# 268
DEFB 0
# 268
DEFB 0
# 268
DEFB 0
# 268
DEFB $80
# 268
DEFB $81
defm"--------"
DEFB 0
# 270
DEFB 0
# 270
DEFB 0
# 270
DEFB 0
# 270
DEFB $80
# 270
DEFB $81
defm"--------"
defm"fmod(-10,-3) = -1"
DEFB 0
# 273
DEFB 0
# 273
DEFB 0
# 273
DEFB 0
# 273
DEFB $80
# 273
DEFB $81
defm"--------"
DEFB 0
# 275
DEFB 0
# 275
DEFB 0
# 275
DEFB 0
# 275
DEFB $80
# 275
DEFB $81
defm"--------"
defm"0.00390625 = 0.00390625"
DEFB 0
# 278
DEFB 0
# 278
DEFB 0
# 278
DEFB 0
# 278
DEFB 0
# 278
DEFB $79
defm"--------"
DEFB 0
# 280
DEFB 0
# 280
DEFB 0
# 280
DEFB 0
# 280
DEFB 0
# 280
DEFB $79
defm"--------"
defm"0.0078125 = 0.0078125"
DEFB 0
# 283
DEFB 0
# 283
DEFB 0
# 283
DEFB 0
# 283
DEFB 0
# 283
DEFB $7A
defm"--------"
DEFB 0
# 285
DEFB 0
# 285
DEFB 0
# 285
DEFB 0
# 285
DEFB 0
# 285
DEFB $7A
defm"--------"
defm"0.015625 = 0.015625"
DEFB 0
# 288
DEFB 0
# 288
DEFB 0
# 288
DEFB 0
# 288
DEFB 0
# 288
DEFB $7B
defm"--------"
DEFB 0
# 290
DEFB 0
# 290
DEFB 0
# 290
DEFB 0
# 290
DEFB 0
# 290
DEFB $7B
defm"--------"
defm"0.03125 = 0.03125"
DEFB 0
# 293
DEFB 0
# 293
DEFB 0
# 293
DEFB 0
# 293
DEFB 0
# 293
DEFB $7C
defm"--------"
DEFB 0
# 295
DEFB 0
# 295
DEFB 0
# 295
DEFB 0
# 295
DEFB 0
# 295
DEFB $7C
defm"--------"
defm"0.0625 = 0.0625"
DEFB 0
# 298
DEFB 0
# 298
DEFB 0
# 298
DEFB 0
# 298
DEFB 0
# 298
DEFB $7D
defm"--------"
DEFB 0
# 300
DEFB 0
# 300
DEFB 0
# 300
DEFB 0
# 300
DEFB 0
# 300
DEFB $7D
defm"--------"
defm"0.125 = 0.125"
DEFB 0
# 303
DEFB 0
# 303
DEFB 0
# 303
DEFB 0
# 303
DEFB 0
# 303
DEFB $7E
defm"--------"
DEFB 0
# 305
DEFB 0
# 305
DEFB 0
# 305
DEFB 0
# 305
DEFB 0
# 305
DEFB $7E
defm"--------"
defm"0.25 = 0.25"
DEFB 0
# 308
DEFB 0
# 308
DEFB 0
# 308
DEFB 0
# 308
DEFB 0
# 308
DEFB $7F
defm"--------"
DEFB 0
# 310
DEFB 0
# 310
DEFB 0
# 310
DEFB 0
# 310
DEFB 0
# 310
DEFB $7F
defm"--------"
defm"0.5 = 0.5"
DEFB 0
# 313
DEFB 0
# 313
DEFB 0
# 313
DEFB 0
# 313
DEFB 0
# 313
DEFB $80
defm"--------"
DEFB 0
# 315
DEFB 0
# 315
DEFB 0
# 315
DEFB 0
# 315
DEFB 0
# 315
DEFB $80
defm"--------"
defm"1 = 1"
DEFB 0
# 318
DEFB 0
# 318
DEFB 0
# 318
DEFB 0
# 318
DEFB 0
# 318
DEFB $81
defm"--------"
DEFB 0
# 320
DEFB 0
# 320
DEFB 0
# 320
DEFB 0
# 320
DEFB 0
# 320
DEFB $81
defm"--------"
defm"2 = 2"
DEFB 0
# 323
DEFB 0
# 323
DEFB 0
# 323
DEFB 0
# 323
DEFB 0
# 323
DEFB $82
defm"--------"
DEFB 0
# 325
DEFB 0
# 325
DEFB 0
# 325
DEFB 0
# 325
DEFB 0
# 325
DEFB $82
defm"--------"
defm"4 = 4"
DEFB 0
# 328
DEFB 0
# 328
DEFB 0
# 328
DEFB 0
# 328
DEFB 0
# 328
DEFB $83
defm"--------"
DEFB 0
# 330
DEFB 0
# 330
DEFB 0
# 330
DEFB 0
# 330
DEFB 0
# 330
DEFB $83
defm"--------"
defm"8 = 8"
DEFB 0
# 333
DEFB 0
# 333
DEFB 0
# 333
DEFB 0
# 333
DEFB 0
# 333
DEFB $84
defm"--------"
DEFB 0
# 335
DEFB 0
# 335
DEFB 0
# 335
DEFB 0
# 335
DEFB 0
# 335
DEFB $84
defm"--------"
defm"16 = 16"
DEFB 0
# 338
DEFB 0
# 338
DEFB 0
# 338
DEFB 0
# 338
DEFB 0
# 338
DEFB $85
defm"--------"
DEFB 0
# 340
DEFB 0
# 340
DEFB 0
# 340
DEFB 0
# 340
DEFB 0
# 340
DEFB $85
defm"--------"
defm"32 = 32"
DEFB 0
# 343
DEFB 0
# 343
DEFB 0
# 343
DEFB 0
# 343
DEFB 0
# 343
DEFB $86
defm"--------"
DEFB 0
# 345
DEFB 0
# 345
DEFB 0
# 345
DEFB 0
# 345
DEFB 0
# 345
DEFB $86
defm"--------"
defm"64 = 64"
DEFB 0
# 348
DEFB 0
# 348
DEFB 0
# 348
DEFB 0
# 348
DEFB 0
# 348
DEFB $87
defm"--------"
DEFB 0
# 350
DEFB 0
# 350
DEFB 0
# 350
DEFB 0
# 350
DEFB 0
# 350
DEFB $87
defm"--------"
defm"128 = 128"
DEFB 0
# 353
DEFB 0
# 353
DEFB 0
# 353
DEFB 0
# 353
DEFB 0
# 353
DEFB $88
defm"--------"
DEFB 0
# 355
DEFB 0
# 355
DEFB 0
# 355
DEFB 0
# 355
DEFB 0
# 355
DEFB $88
defm"--------"
defm"256 = 256"
DEFB 0
# 358
DEFB 0
# 358
DEFB 0
# 358
DEFB 0
# 358
DEFB 0
# 358
DEFB $89
defm"--------"
DEFB 0
# 360
DEFB 0
# 360
DEFB 0
# 360
DEFB 0
# 360
DEFB 0
# 360
DEFB $89
defm"--------"
defm"512 = 512"
DEFB 0
# 363
DEFB 0
# 363
DEFB 0
# 363
DEFB 0
# 363
DEFB 0
# 363
DEFB $8A
defm"--------"
DEFB 0
# 365
DEFB 0
# 365
DEFB 0
# 365
DEFB 0
# 365
DEFB 0
# 365
DEFB $8A
defm"--------"
defm"1024 = 1024"
DEFB 0
# 368
DEFB 0
# 368
DEFB 0
# 368
DEFB 0
# 368
DEFB 0
# 368
DEFB $8B
defm"--------"
DEFB 0
# 370
DEFB 0
# 370
DEFB 0
# 370
DEFB 0
# 370
DEFB 0
# 370
DEFB $8B
defm"--------"
defm"2048 = 2048"
DEFB 0
# 373
DEFB 0
# 373
DEFB 0
# 373
DEFB 0
# 373
DEFB 0
# 373
DEFB $8C
defm"--------"
DEFB 0
# 375
DEFB 0
# 375
DEFB 0
# 375
DEFB 0
# 375
DEFB 0
# 375
DEFB $8C
defm"--------"
defm"4096 = 4096"
DEFB 0
# 378
DEFB 0
# 378
DEFB 0
# 378
DEFB 0
# 378
DEFB 0
# 378
DEFB $8D
defm"--------"
DEFB 0
# 380
DEFB 0
# 380
DEFB 0
# 380
DEFB 0
# 380
DEFB 0
# 380
DEFB $8D
defm"--------"
defm"8192 = 8192"
DEFB 0
# 383
DEFB 0
# 383
DEFB 0
# 383
DEFB 0
# 383
DEFB 0
# 383
DEFB $8E
defm"--------"
DEFB 0
# 385
DEFB 0
# 385
DEFB 0
# 385
DEFB 0
# 385
DEFB 0
# 385
DEFB $8E
defm"--------"
defm"16384 = 16384"
DEFB 0
# 388
DEFB 0
# 388
DEFB 0
# 388
DEFB 0
# 388
DEFB 0
# 388
DEFB $8F
defm"--------"
DEFB 0
# 390
DEFB 0
# 390
DEFB 0
# 390
DEFB 0
# 390
DEFB 0
# 390
DEFB $8F
defm"--------"
defm"32768 = 32768"
DEFB 0
# 393
DEFB 0
# 393
DEFB 0
# 393
DEFB 0
# 393
DEFB 0
# 393
DEFB $90
defm"--------"
DEFB 0
# 395
DEFB 0
# 395
DEFB 0
# 395
DEFB 0
# 395
DEFB 0
# 395
DEFB $90
defm"--------"
defm"65536 = 65536"
DEFB 0
# 398
DEFB 0
# 398
DEFB 0
# 398
DEFB 0
# 398
DEFB 0
# 398
DEFB $91
defm"--------"
DEFB 0
# 400
DEFB 0
# 400
DEFB 0
# 400
DEFB 0
# 400
DEFB 0
# 400
DEFB $91
defm"--------"
defm"131072 = 131072"
DEFB 0
# 403
DEFB 0
# 403
DEFB 0
# 403
DEFB 0
# 403
DEFB 0
# 403
DEFB $92
defm"--------"
DEFB 0
# 405
DEFB 0
# 405
DEFB 0
# 405
DEFB 0
# 405
DEFB 0
# 405
DEFB $92
defm"--------"
defm"262144 = 262144"
DEFB 0
# 408
DEFB 0
# 408
DEFB 0
# 408
DEFB 0
# 408
DEFB 0
# 408
DEFB $93
defm"--------"
DEFB 0
# 410
DEFB 0
# 410
DEFB 0
# 410
DEFB 0
# 410
DEFB 0
# 410
DEFB $93
defm"--------"
defm"524288 = 524288"
DEFB 0
# 413
DEFB 0
# 413
DEFB 0
# 413
DEFB 0
# 413
DEFB 0
# 413
DEFB $94
defm"--------"
DEFB 0
# 415
DEFB 0
# 415
DEFB 0
# 415
DEFB 0
# 415
DEFB 0
# 415
DEFB $94
defm"--------"
defm"1048576 = 1048576"
DEFB 0
# 418
DEFB 0
# 418
DEFB 0
# 418
DEFB 0
# 418
DEFB 0
# 418
DEFB $95
defm"--------"
DEFB 0
# 420
DEFB 0
# 420
DEFB 0
# 420
DEFB 0
# 420
DEFB 0
# 420
DEFB $95
defm"--------"
defm"2097152 = 2097152"
DEFB 0
# 423
DEFB 0
# 423
DEFB 0
# 423
DEFB 0
# 423
DEFB 0
# 423
DEFB $96
defm"--------"
DEFB 0
# 425
DEFB 0
# 425
DEFB 0
# 425
DEFB 0
# 425
DEFB 0
# 425
DEFB $96
defm"--------"
defm"4194304 = 4194304"
DEFB 0
# 428
DEFB 0
# 428
DEFB 0
# 428
DEFB 0
# 428
DEFB 0
# 428
DEFB $97
defm"--------"
DEFB 0
# 430
DEFB 0
# 430
DEFB 0
# 430
DEFB 0
# 430
DEFB 0
# 430
DEFB $97
defm"--------"
defm"8388608 = 8388608"
DEFB 0
# 433
DEFB 0
# 433
DEFB 0
# 433
DEFB 0
# 433
DEFB 0
# 433
DEFB $98
defm"--------"
DEFB 0
# 435
DEFB 0
# 435
DEFB 0
# 435
DEFB 0
# 435
DEFB 0
# 435
DEFB $98
defm"--------"
defm"16777216 = 16777216"
DEFB 0
# 438
DEFB 0
# 438
DEFB 0
# 438
DEFB 0
# 438
DEFB 0
# 438
DEFB $99
defm"--------"
DEFB 0
# 440
DEFB 0
# 440
DEFB 0
# 440
DEFB 0
# 440
DEFB 0
# 440
DEFB $99
defm"--------"
defm"0.1 = 0.1"
DEFB $CD
# 443
DEFB $CC
# 443
DEFB $CC
# 443
DEFB $CC
# 443
DEFB $4C
# 443
DEFB $7D
defm"--------"
DEFB $CD
# 445
DEFB $CC
# 445
DEFB $CC
# 445
DEFB $CC
# 445
DEFB $4C
# 445
DEFB $7D
defm"--------"
defm"0.2 = 0.2"
DEFB $CD
# 448
DEFB $CC
# 448
DEFB $CC
# 448
DEFB $CC
# 448
DEFB $4C
# 448
DEFB $7E
defm"--------"
DEFB $CD
# 450
DEFB $CC
# 450
DEFB $CC
# 450
DEFB $CC
# 450
DEFB $4C
# 450
DEFB $7E
defm"--------"
defm"0.333333333333333 = 0.333333333333333"
DEFB $AB
# 453
DEFB $AA
# 453
DEFB $AA
# 453
DEFB $AA
# 453
DEFB $2A
# 453
DEFB $7F
defm"--------"
DEFB $AB
# 455
DEFB $AA
# 455
DEFB $AA
# 455
DEFB $AA
# 455
DEFB $2A
# 455
DEFB $7F
defm"--------"
defm"0 = 0"
DEFB 0
# 458
DEFB 0
# 458
DEFB 0
# 458
DEFB 0
# 458
DEFB 0
# 458
DEFB 0
defm"--------"
DEFB 0
# 460
DEFB 0
# 460
DEFB 0
# 460
DEFB 0
# 460
DEFB 0
# 460
DEFB 0
defm"--------"
defm"1 = 1"
DEFB 0
# 463
DEFB 0
# 463
DEFB 0
# 463
DEFB 0
# 463
DEFB 0
# 463
DEFB $81
defm"--------"
DEFB 0
# 465
DEFB 0
# 465
DEFB 0
# 465
DEFB 0
# 465
DEFB 0
# 465
DEFB $81
defm"--------"
defm"-1 = -1"
DEFB 0
# 468
DEFB 0
# 468
DEFB 0
# 468
DEFB 0
# 468
DEFB $80
# 468
DEFB $81
defm"--------"
DEFB 0
# 470
DEFB 0
# 470
DEFB 0
# 470
DEFB 0
# 470
DEFB $80
# 470
DEFB $81
defm"--------"
defm"255 = 255"
DEFB 0
# 473
DEFB 0
# 473
DEFB 0
# 473
DEFB 0
# 473
DEFB $7F
# 473
DEFB $88
defm"--------"
DEFB 0
# 475
DEFB 0
# 475
DEFB 0
# 475
DEFB 0
# 475
DEFB $7F
# 475
DEFB $88
defm"--------"
defm"-255 = -255"
DEFB 0
# 478
DEFB 0
# 478
DEFB 0
# 478
DEFB 0
# 478
DEFB $FF
# 478
DEFB $88
defm"--------"
DEFB 0
# 480
DEFB 0
# 480
DEFB 0
# 480
DEFB 0
# 480
DEFB $FF
# 480
DEFB $88
defm"--------"
defm"256 = 256"
DEFB 0
# 483
DEFB 0
# 483
DEFB 0
# 483
DEFB 0
# 483
DEFB 0
# 483
DEFB $89
defm"--------"
DEFB 0
# 485
DEFB 0
# 485
DEFB 0
# 485
DEFB 0
# 485
DEFB 0
# 485
DEFB $89
defm"--------"
defm"-256 = -256"
DEFB 0
# 488
DEFB 0
# 488
DEFB 0
# 488
DEFB 0
# 488
DEFB $80
# 488
DEFB $89
defm"--------"
DEFB 0
# 490
DEFB 0
# 490
DEFB 0
# 490
DEFB 0
# 490
DEFB $80
# 490
DEFB $89
defm"--------"
defm"65535 = 65535"
DEFB 0
# 493
DEFB 0
# 493
DEFB 0
# 493
DEFB $FF
# 493
DEFB $7F
# 493
DEFB $90
defm"--------"
DEFB 0
# 495
DEFB 0
# 495
DEFB 0
# 495
DEFB $FF
# 495
DEFB $7F
# 495
DEFB $90
defm"--------"
defm"-65535 = -65535"
DEFB 0
# 498
DEFB 0
# 498
DEFB 0
# 498
DEFB $FF
# 498
DEFB $FF
# 498
DEFB $90
defm"--------"
DEFB 0
# 500
DEFB 0
# 500
DEFB 0
# 500
DEFB $FF
# 500
DEFB $FF
# 500
DEFB $90
defm"--------"
defm"65536 = 65536"
DEFB 0
# 503
DEFB 0
# 503
DEFB 0
# 503
DEFB 0
# 503
DEFB 0
# 503
DEFB $91
defm"--------"
DEFB 0
# 505
DEFB 0
# 505
DEFB 0
# 505
DEFB 0
# 505
DEFB 0
# 505
DEFB $91
defm"--------"
defm"-65536 = -65536"
DEFB 0
# 508
DEFB 0
# 508
DEFB 0
# 508
DEFB 0
# 508
DEFB $80
# 508
DEFB $91
defm"--------"
DEFB 0
# 510
DEFB 0
# 510
DEFB 0
# 510
DEFB 0
# 510
DEFB $80
# 510
DEFB $91
defm"--------"
defm"5.5 = 5.5"
DEFB 0
# 513
DEFB 0
# 513
DEFB 0
# 513
DEFB 0
# 513
DEFB $30
# 513
DEFB $83
defm"--------"
DEFB 0
# 515
DEFB 0
# 515
DEFB 0
# 515
DEFB 0
# 515
DEFB $30
# 515
DEFB $83
defm"--------"
defm"-5.5 = -5.5"
DEFB 0
# 518
DEFB 0
# 518
DEFB 0
# 518
DEFB 0
# 518
DEFB $B0
# 518
DEFB $83
defm"--------"
DEFB 0
# 520
DEFB 0
# 520
DEFB 0
# 520
DEFB 0
# 520
DEFB $B0
# 520
DEFB $83
defm"--------"
defm"55 = 55"
DEFB 0
# 523
DEFB 0
# 523
DEFB 0
# 523
DEFB 0
# 523
DEFB $5C
# 523
DEFB $86
defm"--------"
DEFB 0
# 525
DEFB 0
# 525
DEFB 0
# 525
DEFB 0
# 525
DEFB $5C
# 525
DEFB $86
defm"--------"
defm"0.5 = 0.5"
DEFB 0
# 528
DEFB 0
# 528
DEFB 0
# 528
DEFB 0
# 528
DEFB 0
# 528
DEFB $80
defm"--------"
DEFB 0
# 530
DEFB 0
# 530
DEFB 0
# 530
DEFB 0
# 530
DEFB 0
# 530
DEFB $80
