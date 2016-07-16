#ifndef STLPLUS_SIMPLE_PTR
#define STLPLUS_SIMPLE_PTR
////////////////////////////////////////////////////////////////////////////////

//   Author:    Daniel Milton
//   Copyright: (c) Daniel Milton           2002 onwards
//   License:   BSD License, see ../docs/license.html

//   A smart pointer is a memory-managing pointer to an object. If you like, it
//   is a zero-dimensional container.

//   Assignment of smart pointers result in multiple aliases of the same object.
//   The term alias is used to differentiate from conventional pointers because
//   the semantics are different.

//   Aliases can be turned into copies if the pointed-to class supports copying.

//   These simple_ptr classes from DJDM have slightly different semantics than
//   the smart_ptr classes of AJR. There are no cross-pointer side effects
//   that occur when the pointer is cleared. The clear() function is effectively
//   equivalent to the clear_unique() function of the smart_ptr. The only way
//   that a "referenced" object will be deleted is if all simple_ptr's that
//   reference the object are cleared (by deletion, manual clearing or reassignment).

//   Also, the simple pointer cannot contain a reference to a shared null pointer
//   (which occurs as a side-effect of clearing a multiply referenced object in
//   the smart_ptr classes). Which means that if you have a null simple_ptr, then
//   the assignment of any other null simple_ptr will NOT reassign the reference of
//   any other simple_ptr. Hence, the simple_ptr class acts a little more like a
//   normal pointer (with fewer side effects), with the added bonus of containment.

//   Due to the way that the simple_ptr contains the data, it also allows the
//   addition of various casting functions, while still keeping the managed data
//   containment functionality of the underlying object. This means that you can
//   have two simple_ptr's of different template types, both pointing to the same
//   data (if the differing template types are derivatives of each other).

//   The base class is simple_ptr_base which defines the common interface. Then
//   there are three subclasses which have the same interface but different copy
//   semantics:

//   - simple_ptr        for simple types and classes which have copy constructors
//   - simple_ptr_clone  for polymorphic class hierarchies which are copied using a clone method
//   - simple_ptr_nocopy for any class that cannot or should not be copied

////////////////////////////////////////////////////////////////////////////////
#include "containers_fixes.hpp"
#include "exceptions.hpp"
#include "copy_functors.hpp"
#include <map>
#include <string>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // Base class
  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, typename C>
  class simple_ptr_base
  {
  public:
    //////////////////////////////////////////////////////////////////////////////
    // member type definitions

    typedef T value_type;
    typedef T& reference;
    typedef const T& const_reference;
    typedef C value_copy;

    //////////////////////////////////////////////////////////////////////////////
    // constructors and destructors

    // create a null pointer
    simple_ptr_base(void);

    // create a pointer containing a dynamically created object
    // Note: the object must be allocated *by the user* with new
    // constructor form - must be called in the form smart_ptr_base<type> x(new type(args))
    explicit simple_ptr_base(T* data);

    // copy constructor implements aliasing so no copy is made
    // note that the copy constructor should NOT be explicit, as this breaks
    // the returning of pointer objects from functions (at least within GCC 4.4)
    simple_ptr_base(const simple_ptr_base<T,C>& r);

    // assignment operator - required, else the output of GCC suffers segmentation faults
    simple_ptr_base<T,C>& operator=(const simple_ptr_base<T,C>& r);

    // destructor decrements the reference count and delete only when the last reference is destroyed
    ~simple_ptr_base(void);

    //////////////////////////////////////////////////////////////////////////////
    // logical tests to see if there is anything contained in the pointer since it can be null

    // there are two forms:explicit and implicit
    // implicit: if(!r) or if(r)
    // explicit: if(r.null()) or if(r.present())
    operator bool(void) const;
    bool operator!(void) const;
    bool present(void) const;
    bool null(void) const;

    //////////////////////////////////////////////////////////////////////////////
    // dereference operators and functions

    // dereference the smart pointer to get the object - use in the form *p1
    T& operator*(void) throw(null_dereference);
    const T& operator*(void) const throw(null_dereference);

    // used as a prefix to a member access to the contained object e.g. p1->print() calls T::print()
    T* operator->(void) throw(null_dereference);
    const T* operator->(void) const throw(null_dereference);

    //////////////////////////////////////////////////////////////////////////////
    // explicit function forms of the above assignment and dereference operators

    // get the value
    T& value(void) throw(null_dereference);
    const T& value(void) const throw(null_dereference);

    // set the pointer
    // deletes the previous pointer and adopts the passed pointer instead
    // Note: the object must be allocated *by the user* with new
    // Warning: it is very easy to break the memory management with this operation
    void set(T* data = 0);
    // get the pointer
    T* pointer(void);
    const T* pointer(void) const;

    //////////////////////////////////////////////////////////////////////////////
    // functions to manage aliases

    // make this an alias of the passed object
    void alias(const simple_ptr_base<T,C>&);

    // test whether two pointers point to the same object(known as aliasing the object)
    // used in the form if(a.aliases(b))
    bool aliases(const simple_ptr_base<T,C>&) const;

    // find the number of aliases - used when you need to know whether an
    // object is still referred to from elsewhere (rare!)
    unsigned alias_count(void) const;

    // clear the reference to the object, but only delete the object if there are no
    // other references to that object. Hence, this does not affect other pointers
    // that are pointing to the same object.
    void clear(void);

    // This is just an alias of the clear() function, provided for completeness of
    // the interface when acting as a replacement for the smart_ptr classes
    void clear_unique(void);

    //////////////////////////////////////////////////////////////////////////////
    // functions that involve copying

    // these functions use the copy functor passed as the template parameter C
    // to copy the object with the right copy semantics. If the copy functor
    // is no_copy, an exception will be thrown.

    // create a pointer containing a *copy* of the object using the template parameter C
    // this copy is taken because the pointer class maintains a dynamically allocated object
    // and the T& may not be (usually is not) dynamically allocated
    explicit simple_ptr_base(const T& data) throw(illegal_copy);

    // set the value - note that this does a copy using the C template parameter
    void set_value(const T& data) throw(illegal_copy);

    // make this pointer unique with respect to any other references to the same object
    // if this pointer is already unique, it does nothing - otherwise it copies the object
    void make_unique(void) throw(illegal_copy);

    // make this pointer a unique copy of the parameter
    // useful for expressions like p1.copy(p2) which makes p1 a pointer to a unique copy of the contents of p2
    void copy(const simple_ptr_base<T,C>&) throw(illegal_copy);

    //////////////////////////////////////////////////////////////////////////////

  protected:
    T* m_pointer;
    unsigned* m_count;

  public:
    // internal use only - had to make them public because they need to be
    // accessed by routines that could not be made friends
    // can't have a handle due to the way the simple pointer stores it's data
    // in separate counter and pointer objects
    unsigned* _count(void) const;
    T* _pointer(void) const;
    void _make_alias(T* pointer, unsigned* const& count);

  private:
    inline void increment(void);
    inline bool decrement(void);
    inline void _delete_pointer(void);
  };

  ////////////////////////////////////////////////////////////////////////////////
  // simple_ptr        for simple types and classes which have copy constructors

  template <typename T>
  class simple_ptr : public simple_ptr_base<T, constructor_copy<T> >
  {
  public:
    simple_ptr(void) {}
    explicit simple_ptr(const T& data) : simple_ptr_base<T, constructor_copy<T> >(data) {}
    explicit simple_ptr(T* data) : simple_ptr_base<T, constructor_copy<T> >(data) {}
    simple_ptr<T>& operator=(const T& data) {this->set_value(data); return *this;}
    simple_ptr<T>& operator=(T* data) {this->set(data); return *this;}
    ~simple_ptr(void) {}

#ifdef STLPLUS_MEMBER_TEMPLATES
    // functions that involve casting
    // moved from base class for two main reasons, though the second is a feature of the first:

    // 1. GCC cannot cast the previous base result of simple_ptr_base<T2, constructor_copy<T> >
    //    as a simple_ptr<T2> even though it used to look like a duck and quack like a duck.
    //    I think it was really complaining that the copy class was not guaranteed to be the same.

    // 2. Within the cast routines, one pointer type tried accessing private data of the other
    //    pointer type and even though they are really the same type, was not allowed. Because
    //    of this, the "private" function _make_alias is utilised to get the same result.

    // By having the cast functions in each derived class, you are guaranteed to use the same
    // copy class - no question. GCC is ok with this.

    template<typename T2> simple_ptr<T2> dyn_cast(void) const;
    template<typename T2> simple_ptr<T2> stat_cast(void) const;
    template<typename T2> simple_ptr<T2> cast(void) const;
#endif
  };

  ////////////////////////////////////////////////////////////////////////////////
  // simple_ptr_clone  for polymorphic class hierarchies which have a clone method

  template <typename T>
  class simple_ptr_clone : public simple_ptr_base<T, clone_copy<T> >
  {
  public:
    simple_ptr_clone(void) {}
    explicit simple_ptr_clone(const T& data) : simple_ptr_base<T, clone_copy<T> >(data) {}
    explicit simple_ptr_clone(T* data) : simple_ptr_base<T, clone_copy<T> >(data) {}
    simple_ptr_clone<T>& operator=(const T& data) {this->set_value(data); return *this;}
    simple_ptr_clone<T>& operator=(T* data) {this->set(data); return *this;}
    ~simple_ptr_clone(void) {}

#ifdef STLPLUS_MEMBER_TEMPLATES
    // functions that involve casting
    // moved from base class - see simple_ptr above
    template<typename T2> simple_ptr_clone<T2> dyn_cast(void) const;
    template<typename T2> simple_ptr_clone<T2> stat_cast(void) const;
    template<typename T2> simple_ptr_clone<T2> cast(void) const;
#endif
};

  ////////////////////////////////////////////////////////////////////////////////
  // simple_ptr_nocopy for any class that cannot or should not be copied

  template <typename T>
  class simple_ptr_nocopy : public simple_ptr_base<T, no_copy<T> >
  {
  public:
    simple_ptr_nocopy(void) {}
    explicit simple_ptr_nocopy(T* data) : simple_ptr_base<T, no_copy<T> >(data) {}
    simple_ptr_nocopy<T>& operator=(T* data) {this->set(data); return *this;}
    ~simple_ptr_nocopy(void) {}

#ifdef STLPLUS_MEMBER_TEMPLATES
    // functions that involve casting
    // moved from base class - see simple_ptr above
    template<typename T2> simple_ptr_nocopy<T2> dyn_cast(void) const;
    template<typename T2> simple_ptr_nocopy<T2> stat_cast(void) const;
    template<typename T2> simple_ptr_nocopy<T2> cast(void) const;
#endif
  };

  ////////////////////////////////////////////////////////////////////////////////
  // internally, simple_ptr allocates lots of count values, which are just
  // unsigned reference counts. The allocation of these values benefit from
  // being allocated from a dedicated pool, as this increases the speed
  // therefore I have now provided the ability to override the memory management
  // of these values without needing to override the global new/delete
  // all you need to do is to define these functions BEFORE including this file
  // and set the override definition
#ifndef STLPLUS_SIMPLE_PTR_REFCOUNT_ALLOC_OVERRIDE
  inline unsigned* simple_ptr_refcount_new() {
	  return new unsigned(1);
  }
  inline void simple_ptr_refcount_delete(unsigned* pCount) {
	  delete pCount;
  }
#endif

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#include "simple_ptr.tpp"
#endif
