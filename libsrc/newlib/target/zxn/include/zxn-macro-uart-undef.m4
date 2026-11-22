pushdef(`Z88DK_DIVNUM', divnum)
divert(-1)

# Local Macros

popdef(`__CLK_28_0')
popdef(`__CLK_28_1')
popdef(`__CLK_28_2')
popdef(`__CLK_28_3')
popdef(`__CLK_28_4')
popdef(`__CLK_28_5')
popdef(`__CLK_28_6')
popdef(`__CLK_28_7')

# Compute UART Prescalar from Clock, Baud Rate

popdef(`UART_PRESCALAR_L')
popdef(`UART_PRESCALAR_H')

divert(Z88DK_DIVNUM)
dnl`'popdef(`Z88DK_DIVNUM')
