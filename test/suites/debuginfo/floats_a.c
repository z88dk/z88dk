/* Floats print their value, in the format of the module that defines them (__fp_mode,
 * __fp_exponent_bias and __fp_mantissa_size in the map). The values are exact in every
 * format. */
#include "floats.h"

struct fs { int i; float f; };

float ga_f = -3.25;
float ga_arr[3] = { 1.5, -2.0, 100.0 };
float *ga_ptr = &ga_arr[1];
struct fs ga_st = { 7, 0.5 };
struct pay ga_pay = { -0.75 };
struct box ga_box = { { &ga_pay, &ga_pay } };
struct tail ga_tail = { 2.5, 77 };
int ga_int = 5;

extern int fb(void);
extern int fn(void);

int main(void)
{
    ga_int = fb() + fn();
    return 0;           /* <-- check_floats.sh BREAK LINE */
}
