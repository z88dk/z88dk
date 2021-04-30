

void function(void *ptr, long val, int offs);


void main()
{
    function((void *)&main, 1, 3);
}
