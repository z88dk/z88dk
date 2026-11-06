/* z88 (BBC BASIC) integer form: exponent byte 0 after a 32-bit two's complement
 * integer in the four mantissa bytes (the first byte unused): -2 and 2 */
unsigned char gi_nbuf[6] = { 0x00, 0xfe, 0xff, 0xff, 0xff, 0x00 };
unsigned char gi_pbuf[6] = { 0x00, 0x02, 0x00, 0x00, 0x00, 0x00 };
float *gi_neg = (float *)gi_nbuf;
float *gi_pos = (float *)gi_pbuf;
float gi_zero = 0.0;

int main(void)
{
    return 0;
}
