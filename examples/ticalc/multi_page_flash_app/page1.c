#define page1
#include "shared.h"


// It should be noted that Global variables in another page will not work!!!


// Global non-constant variables are typically set at a constant location in ram, 
// and therefore are not able to be implemented in an efficient way with multiple pages. 





// This should be something large you want to relocate on another page
char add_three_numbers(char x, char y, char z){
	return x+y+z;
} 

// Entry point on another page
char add_three_numbers_(char x, char y, char z) __banked{
	return add_three_numbers(x, y, z);
} 





// Circular multi-page call. Allows you to call a function in main.c from page1.c

char add_plus_1(char x, char y){
	return add_two_number_(x, y) + 1;
}

char add_plus_1_(char x, char y) __banked{
	return add_plus_1(x, y);
}