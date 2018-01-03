
typedef struct {
        int _x;
        int     _y;
        int _status;
} Character;

typedef struct {
   Character  _character;
} Item;

void value(int v);

void func3(Item *item)
{
   return (long)item->_character->_x;

}
void func2(int val)
{
	value( (((Character *) val))->_y);
}

void func(Item *itemptr)
{
	value( ( (Character *) itemptr )->_y);
}
