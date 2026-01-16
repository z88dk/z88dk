pushdef(`Z88DK_DIVNUM', divnum)
divert(-1)

# Local Macros

pushdef(`__CLK_28_0', 28000000)
pushdef(`__CLK_28_1', 28571429)
pushdef(`__CLK_28_2', 29464286)
pushdef(`__CLK_28_3', 30000000)
pushdef(`__CLK_28_4', 31000000)
pushdef(`__CLK_28_5', 32000000)
pushdef(`__CLK_28_6', 33000000)
pushdef(`__CLK_28_7', 27000000)

# Compute UART Prescalar from Clock, Baud Rate

pushdef(`UART_PRESCALAR_L', `0x`'eval(((($1)+($1)+($2))/($2)/2) & 0x7f,16,2)')
pushdef(`UART_PRESCALAR_H', `0x`'`eval(((((($1)+($1)+($2))/($2)/2) >> 7) & 0x7f) + 0x80,16,2)')

divert(Z88DK_DIVNUM)
dnl`'popdef(`Z88DK_DIVNUM')
