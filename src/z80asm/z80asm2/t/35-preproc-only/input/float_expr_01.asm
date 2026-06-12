defm "--------"
defm "1 = 1"
float 1
defm "--------"
float 1
defm "--------"
defm "pi = 3.14159265358979"
float pi
defm "--------"
float 3.14159265358979
defm "--------"
defm "e = 2.71828182845905"
float e
defm "--------"
float 2.71828182845905
defm "--------"
defm "1+.5 = 1.5"
float 1+.5
defm "--------"
float 1.5
defm "--------"
defm "1-.5 = 0.5"
float 1-.5
defm "--------"
float 0.5
defm "--------"
defm "1+-.5 = 0.5"
float 1+-.5
defm "--------"
float 0.5
defm "--------"
defm "2*4 = 8"
float 2*4
defm "--------"
float 8
defm "--------"
defm "2/4 = 0.5"
float 2/4
defm "--------"
float 0.5
defm "--------"
defm "2*-4 = -8"
float 2*-4
defm "--------"
float -8
defm "--------"
defm "2**8 = 256"
float 2**8
defm "--------"
float 256
defm "--------"
defm "4**3**2 = 262144"
float 4**3**2
defm "--------"
float 262144
defm "--------"
defm "(4**3)**2 = 4096"
float (4**3)**2
defm "--------"
float 4096
defm "--------"
defm "4**(0.5) = 2"
float 4**(0.5)
defm "--------"
float 2
defm "--------"
defm "+4 = 4"
float +4
defm "--------"
float 4
defm "--------"
defm "+ +4 = 4"
float + +4
defm "--------"
float 4
defm "--------"
defm "+ + -4 = -4"
float + + -4
defm "--------"
float -4
defm "--------"
defm "+ + - +4 = -4"
float + + - +4
defm "--------"
float -4
defm "--------"
defm "2+3*4 = 14"
float 2+3*4
defm "--------"
float 14
defm "--------"
defm "(2+3)*4 = 20"
float (2+3)*4
defm "--------"
float 20
defm "--------"
defm "2*3+4 = 10"
float 2*3+4
defm "--------"
float 10
defm "--------"
defm "2*(3+4) = 14"
float 2*(3+4)
defm "--------"
float 14
defm "--------"
defm "sin(0.5) = 0.479425538604203"
float sin(0.5)
defm "--------"
float 0.479425538604203
defm "--------"
defm "asin(sin(0.5)) = 0.5"
float asin(sin(0.5))
defm "--------"
float 0.5
defm "--------"
defm "cos(0.5) = 0.877582561890373"
float cos(0.5)
defm "--------"
float 0.877582561890373
defm "--------"
defm "acos(cos(0.5)) = 0.5"
float acos(cos(0.5))
defm "--------"
float 0.5
defm "--------"
defm "tan(0.5) = 0.54630248984379"
float tan(0.5)
defm "--------"
float 0.54630248984379
defm "--------"
defm "atan(tan(0.5)) = 0.5"
float atan(tan(0.5))
defm "--------"
float 0.5
defm "--------"
defm "sinh(0.5) = 0.521095305493747"
float sinh(0.5)
defm "--------"
float 0.521095305493747
defm "--------"
defm "asinh(sinh(0.5)) = 0.5"
float asinh(sinh(0.5))
defm "--------"
float 0.5
defm "--------"
defm "cosh(0.5) = 1.12762596520638"
float cosh(0.5)
defm "--------"
float 1.12762596520638
defm "--------"
defm "acosh(cosh(0.5)) = 0.5"
float acosh(cosh(0.5))
defm "--------"
float 0.5
defm "--------"
defm "tanh(0.5) = 0.46211715726001"
float tanh(0.5)
defm "--------"
float 0.46211715726001
defm "--------"
defm "atanh(tanh(0.5)) = 0.5"
float atanh(tanh(0.5))
defm "--------"
float 0.5
defm "--------"
defm "atan2(0.5,0.5) = 0.785398163397448"
float atan2(0.5,0.5)
defm "--------"
float 0.785398163397448
defm "--------"
defm "log(2.7) = 0.993251773010283"
float log(2.7)
defm "--------"
float 0.993251773010283
defm "--------"
defm "log2(2.5) = 1.32192809488736"
float log2(2.5)
defm "--------"
float 1.32192809488736
defm "--------"
defm "log10(15) = 1.17609125905568"
float log10(15)
defm "--------"
float 1.17609125905568
defm "--------"
defm "exp(2) = 7.38905609893065"
float exp(2)
defm "--------"
float 7.38905609893065
defm "--------"
defm "exp2(2) = 4"
float exp2(2)
defm "--------"
float 4
defm "--------"
defm "pow(2,4) = 16"
float pow(2,4)
defm "--------"
float 16
defm "--------"
defm "sqrt(4) = 2"
float sqrt(4)
defm "--------"
float 2
defm "--------"
defm "cbrt(8) = 2"
float cbrt(8)
defm "--------"
float 2
defm "--------"
defm "ceil(2.5) = 3"
float ceil(2.5)
defm "--------"
float 3
defm "--------"
defm "ceil(-2.5) = -2"
float ceil(-2.5)
defm "--------"
float -2
defm "--------"
defm "floor(2.5) = 2"
float floor(2.5)
defm "--------"
float 2
defm "--------"
defm "floor(-2.5) = -3"
float floor(-2.5)
defm "--------"
float -3
defm "--------"
defm "trunc(2.5) = 2"
float trunc(2.5)
defm "--------"
float 2
defm "--------"
defm "trunc(-2.5) = -2"
float trunc(-2.5)
defm "--------"
float -2
defm "--------"
defm "abs(2.5) = 2.5"
float abs(2.5)
defm "--------"
float 2.5
defm "--------"
defm "abs(-2.5) = 2.5"
float abs(-2.5)
defm "--------"
float 2.5
defm "--------"
defm "hypot(2,3) = 3.60555127546399"
float hypot(2,3)
defm "--------"
float 3.60555127546399
defm "--------"
defm "fmod(10,3) = 1"
float fmod(10,3)
defm "--------"
float 1
defm "--------"
defm "fmod(10,-3) = 1"
float fmod(10,-3)
defm "--------"
float 1
defm "--------"
defm "fmod(-10,3) = -1"
float fmod(-10,3)
defm "--------"
float -1
defm "--------"
defm "fmod(-10,-3) = -1"
float fmod(-10,-3)
defm "--------"
float -1
defm "--------"
defm "0.00390625 = 0.00390625"
float 0.00390625
defm "--------"
float 0.00390625
defm "--------"
defm "0.0078125 = 0.0078125"
float 0.0078125
defm "--------"
float 0.0078125
defm "--------"
defm "0.015625 = 0.015625"
float 0.015625
defm "--------"
float 0.015625
defm "--------"
defm "0.03125 = 0.03125"
float 0.03125
defm "--------"
float 0.03125
defm "--------"
defm "0.0625 = 0.0625"
float 0.0625
defm "--------"
float 0.0625
defm "--------"
defm "0.125 = 0.125"
float 0.125
defm "--------"
float 0.125
defm "--------"
defm "0.25 = 0.25"
float 0.25
defm "--------"
float 0.25
defm "--------"
defm "0.5 = 0.5"
float 0.5
defm "--------"
float 0.5
defm "--------"
defm "1 = 1"
float 1
defm "--------"
float 1
defm "--------"
defm "2 = 2"
float 2
defm "--------"
float 2
defm "--------"
defm "4 = 4"
float 4
defm "--------"
float 4
defm "--------"
defm "8 = 8"
float 8
defm "--------"
float 8
defm "--------"
defm "16 = 16"
float 16
defm "--------"
float 16
defm "--------"
defm "32 = 32"
float 32
defm "--------"
float 32
defm "--------"
defm "64 = 64"
float 64
defm "--------"
float 64
defm "--------"
defm "128 = 128"
float 128
defm "--------"
float 128
defm "--------"
defm "256 = 256"
float 256
defm "--------"
float 256
defm "--------"
defm "512 = 512"
float 512
defm "--------"
float 512
defm "--------"
defm "1024 = 1024"
float 1024
defm "--------"
float 1024
defm "--------"
defm "2048 = 2048"
float 2048
defm "--------"
float 2048
defm "--------"
defm "4096 = 4096"
float 4096
defm "--------"
float 4096
defm "--------"
defm "8192 = 8192"
float 8192
defm "--------"
float 8192
defm "--------"
defm "16384 = 16384"
float 16384
defm "--------"
float 16384
defm "--------"
defm "32768 = 32768"
float 32768
defm "--------"
float 32768
defm "--------"
defm "65536 = 65536"
float 65536
defm "--------"
float 65536
defm "--------"
defm "131072 = 131072"
float 131072
defm "--------"
float 131072
defm "--------"
defm "262144 = 262144"
float 262144
defm "--------"
float 262144
defm "--------"
defm "524288 = 524288"
float 524288
defm "--------"
float 524288
defm "--------"
defm "1048576 = 1048576"
float 1048576
defm "--------"
float 1048576
defm "--------"
defm "2097152 = 2097152"
float 2097152
defm "--------"
float 2097152
defm "--------"
defm "4194304 = 4194304"
float 4194304
defm "--------"
float 4194304
defm "--------"
defm "8388608 = 8388608"
float 8388608
defm "--------"
float 8388608
defm "--------"
defm "16777216 = 16777216"
float 16777216
defm "--------"
float 16777216
defm "--------"
defm "0.1 = 0.1"
float 0.1
defm "--------"
float 0.1
defm "--------"
defm "0.2 = 0.2"
float 0.2
defm "--------"
float 0.2
defm "--------"
defm "0.333333333333333 = 0.333333333333333"
float 0.333333333333333
defm "--------"
float 0.333333333333333
defm "--------"
defm "0 = 0"
float 0
defm "--------"
float 0
defm "--------"
defm "1 = 1"
float 1
defm "--------"
float 1
defm "--------"
defm "-1 = -1"
float -1
defm "--------"
float -1
defm "--------"
defm "255 = 255"
float 255
defm "--------"
float 255
defm "--------"
defm "-255 = -255"
float -255
defm "--------"
float -255
defm "--------"
defm "256 = 256"
float 256
defm "--------"
float 256
defm "--------"
defm "-256 = -256"
float -256
defm "--------"
float -256
defm "--------"
defm "65535 = 65535"
float 65535
defm "--------"
float 65535
defm "--------"
defm "-65535 = -65535"
float -65535
defm "--------"
float -65535
defm "--------"
defm "65536 = 65536"
float 65536
defm "--------"
float 65536
defm "--------"
defm "-65536 = -65536"
float -65536
defm "--------"
float -65536
defm "--------"
defm "5.5 = 5.5"
float 5.5
defm "--------"
float 5.5
defm "--------"
defm "-5.5 = -5.5"
float -5.5
defm "--------"
float -5.5
defm "--------"
defm "55 = 55"
float 55
defm "--------"
float 55
defm "--------"
defm "0.5 = 0.5"
float 0.5
defm "--------"
float 0.5
