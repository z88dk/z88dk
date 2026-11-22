
typedef int *PTR;

PTR gdi;                 /* Word or integer or address pointer */
PTR gsp;                 /* Data stack pointer */

void func_global()
{
    *--(int *)gsp = *++(int *)gdi;
}

void func_local()
{
    PTR di;                 /* Word or integer or address pointer */
    PTR sp;                 /* Data stack pointer */
    *--(int *)sp = *++(int *)di;
}

void func_mixed1()
{
    PTR sp;                 /* Data stack pointer */
    *--(int *)sp = *++(int *)gdi;
}

void func_mixed2()
{
    PTR di;                 /* Word or integer or address pointer */
    *--(int *)gsp = *++(int *)di;
}
