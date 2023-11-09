#define page1
#include "shared.h"





char add_three_numbers(char x, char y, char z){
	return x+y+z;
} 
char add_three_numbers_(char x, char y, char z) __banked{
	return add_three_numbers(x, y, z);
} 




char add_plus_1(char x, char y){
	// Call on another page
	return add_two_number_(x, y) + 1;
}

char add_plus_1_(char x, char y) __banked{
	return add_plus_1(x, y);
}