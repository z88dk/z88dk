
typedef struct {
        int _x;
        int     _y;
        int _status;
} Character;

typedef struct {
   Character  _character;
} Item;

void value(int v);


long func3(Item *item)
{
   return (long)item->_character._x;

}
void func2(int val)
{
	value( (((Character *) val))->_y);
}

void func(Item *itemptr)
{
	value( ( (Character *) itemptr )->_y);
}


Item item;

void func4()
{
    value( (((Character *) &item))->_y);
}

long func5()
{
   return (long)item._character._x;
}
