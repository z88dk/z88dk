/* Floats computed at run time by the float library, read in the module's format.
 * bbc stores floor() and ceil() in its integer form (exponent 0) */
#include <math.h>

float gr_a = -3.25, gr_b, gr_c, gr_floor, gr_ceil;
float gr_arr[2];
float *gr_ptr = &gr_arr[1];

int main(void)
{
    gr_b = gr_a * 2.0 + 0.5;
    gr_c = gr_a / 1000.0;
    gr_arr[1] = gr_b * gr_b;
    gr_floor = floor(2.7);
    gr_ceil = ceil(-2.2);
    return 0;           /* <-- check_floats_run.sh BREAK LINE */
}
