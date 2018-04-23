
void func(int);
int main()
{
        int     i;
        for ( int i = 0; i< 10; i++ ) {
                int i;
                func(12);
        }
        {
                int i;
                func(i);
        }
        func    (i);
}

