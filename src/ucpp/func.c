#define X(fmt,...) printf(fmt,__VA_ARGS__)

#asm

#endasm

int main()
{
	X("abc%d",1);
}
