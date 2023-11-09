#define page0 

#include "shared.h"
#include <stdio.h>

int main(){
	puts("1+2+3:");
	putchar('0'+ add_three_numbers_(1, 2, 3));
	putchar('\n');
}



char add_two_number(char x, char y){
	return x+y;
}


//  We wrap add_two_number in a banked function call so it can be called between pages.
//  call "add_two_number_" on cross-page calls
//  call "add_two_number" on same-page to avoid overhead (Banked calls add 570-1300 cycles)

//  More info on TI system call overhead: https://wikiti.brandonw.net/index.php?title=83Plus:OS:How_BCALLs_work

char add_two_number_(char x, char y) __banked{
	return add_two_number(x, y);
}