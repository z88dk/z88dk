
An obstack is a fixed block of memory out of which objects are allocated in stack order.  The interface supplies functions to allow the top object on the stack to be dynamically grown.  When an object is freed, the object as well as all objects allocated after it are freed.  There is no memory overhead in each allocation.

The obstack consists of a six-byte header followed by a block of available memory.

struct obstack
{
   void *fence;     // next available address in obstack
   void *object;    // address of currently growing object at top of stack
   void *end;       // address of byte following the entire obstack
   char mem[0];     // start of obstack memory block
}
