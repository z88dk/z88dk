static int x, y;

unsigned int *func()
{
unsigned int *add = ((unsigned int *)0x7800) + y * 40 + x;
return add;
}


unsigned int *func2()
{
unsigned int *add = ((unsigned char *)0x7800) + y * 40 + x;
return add;
}
