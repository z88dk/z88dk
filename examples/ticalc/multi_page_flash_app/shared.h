#pragma once

// We need this to initilize the branch table
#pragma define MULTI_PAGE_CALLS = 100



/* System call */
#define bcall(__LABEL__) __asm__("rst $28 \nDEFW "__LABEL__"\n")
#define PressAnyKey() bcall("0x4972")





#ifndef page0
extern char add_two_number_(char x, char y) __banked;
#endif

#ifndef page1
extern char add_three_numbers_(char x, char y, char z) __banked;
extern char add_plus_1_(char x, char y) __banked;
#endif