
#include <spectrum.h>

char *testing = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

int main()
{
	/* Save a short block */
	tape_save("test",(void *)32768,testing,26);
}
