#ifndef BANKING_H
#define BANKING_H

extern int func_bank2() __banked;
extern int func_bank3(int value) __banked __z88dk_params_offset(4);

#endif
