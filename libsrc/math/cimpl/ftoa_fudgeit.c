
/* Fudging function to cope with inaccuracies in math32 */
int ftoa_fudgeit(float x, float scale)
{
    float z = x / scale;
    float c;
    int   b;

    b = z;
    c = z - (double)b;
    if  ( c > 0.999999 ) return b + 1;

    return b;
}
