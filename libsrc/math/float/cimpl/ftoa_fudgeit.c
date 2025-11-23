
/*
    Fudging function to cope with inaccuracies in math32

    Used in ftoa.c and ftoe.c

#ifdef MUST_ROUND

extern int ftoa_fudgeit(double x, double scale);

                d = ftoa_fudgeit(x, scale) ;
#else
                d = x / scale ;
#endif

    Inserted - May 2019.
    Removed - January 2022.
*/

int ftoa_fudgeit(float x, float scale)
{
    float z = x / scale;
    float c;
    int   b;

    b = (int)z;
    c = z - (float)b;
    if  ( c > 0.999999 ) return b + 1;

    return b;
}
