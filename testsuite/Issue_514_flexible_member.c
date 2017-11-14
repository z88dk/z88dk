
struct flex {
	int	x;
	int	arr[];
};

struct flex2 {
	int	x;
	int	arr[0];
};

int func1() 
{
	struct flex *ptr = 0;

        ptr->arr[3] = 17;

	return sizeof(*ptr);
}

int func2() 
{
	struct flex2 *ptr = 0;

        ptr->arr[3] = 17;

	return sizeof(*ptr);
}

