////////////////////////////////////////////////////////////////////////////////

//   Author:    Daniel Milton
//   Copyright: (c) Daniel Milton           2002 onwards

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // simple_ptr_base class
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  // constructors, assignments and destructors

  // create a null pointer
  template <typename T, typename C>
  simple_ptr_base<T,C>::simple_ptr_base(void) :
    m_pointer(0),
    m_count(0)
  {
  }

  // create a pointer containing a *copy* of the object pointer
  template <typename T, typename C>
  simple_ptr_base<T,C>::simple_ptr_base(const T& data) throw(illegal_copy) :
    m_pointer(C()(data)),
    m_count(0)
  {
  }

  // create a pointer containing a dynamically created object
  // Note: the object must be allocated *by the user* with new
  // constructor form - must be called in the form simple_ptr<type> x(new type(args))
  template <typename T, typename C>
  simple_ptr_base<T,C>::simple_ptr_base(T* data) :
    m_pointer(data),
    m_count(0)
  {
  }

  // copy constructor implements counted referencing - no copy is made
  template <typename T, typename C>
  simple_ptr_base<T,C>::simple_ptr_base(const simple_ptr_base<T,C>& r) :
    m_pointer(r.m_pointer),
    m_count(r.m_count)
  {
    // deferred count allocation
    if (!m_count) {
      m_count = ((simple_ptr_base<T,C>&)r).m_count = simple_ptr_refcount_new();
    }
    increment();
  }

  // assignment operator - required, else the output of GCC suffers segmentation faults
  template <typename T, typename C>
  simple_ptr_base<T,C>& simple_ptr_base<T,C>::operator=(const simple_ptr_base<T,C>& r)
  {
    alias(r);
    return *this;
  }

  // destructor decrements the reference count and delete only when the last reference is destroyed
  template <typename T, typename C>
  simple_ptr_base<T,C>::~simple_ptr_base(void)
  {
    if(decrement()) 
    {
      _delete_pointer();
      if (m_count) {
        simple_ptr_refcount_delete(m_count);
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  // logical tests to see if there is anything contained in the pointer since it can be null

  template <typename T, typename C>
  bool simple_ptr_base<T,C>::null(void) const
  {
    return m_pointer==0;
  }

  template <typename T, typename C>
  bool simple_ptr_base<T,C>::present(void) const
  {
    return m_pointer!=0;
  }

  template <typename T, typename C>
  bool simple_ptr_base<T,C>::operator!(void) const
  {
    return m_pointer==0;
  }

  template <typename T, typename C>
  simple_ptr_base<T,C>::operator bool(void) const
  {
    return m_pointer!=0;
  }

  //////////////////////////////////////////////////////////////////////////////
  // dereference operators and functions

  template <typename T, typename C>
  T& simple_ptr_base<T,C>::operator*(void) throw(null_dereference)
  {
    if (!m_pointer) throw null_dereference("null pointer dereferenced in simple_ptr::operator*");
    return *m_pointer;
  }

  template <typename T, typename C>
  const T& simple_ptr_base<T,C>::operator*(void) const throw(null_dereference)
  {
    if (!m_pointer) throw null_dereference("null pointer dereferenced in simple_ptr::operator*");
    return *m_pointer;
  }

  template <typename T, typename C>
  T* simple_ptr_base<T,C>::operator->(void) throw(null_dereference)
  {
    if (!m_pointer) throw null_dereference("null pointer dereferenced in simple_ptr::operator->");
    return m_pointer;
  }

  template <typename T, typename C>
  const T* simple_ptr_base<T,C>::operator->(void) const throw(null_dereference)
  {
    if (!m_pointer) throw null_dereference("null pointer dereferenced in simple_ptr::operator->");
    return m_pointer;
  }

  //////////////////////////////////////////////////////////////////////////////
  // explicit function forms of the above assignment dereference operators

  template <typename T, typename C>
  void simple_ptr_base<T,C>::set_value(const T& data) throw(illegal_copy)
  {
    set(C()(data));
  }

  template <typename T, typename C>
  T& simple_ptr_base<T,C>::value(void) throw(null_dereference)
  {
    if (!m_pointer) throw null_dereference("null pointer dereferenced in simple_ptr::value");
    return *m_pointer;
  }

  template <typename T, typename C>
  const T& simple_ptr_base<T,C>::value(void) const throw(null_dereference)
  {
    if (!m_pointer) throw null_dereference("null pointer dereferenced in simple_ptr::value");
    return *m_pointer;
  }

  template <typename T, typename C>
  void simple_ptr_base<T,C>::set(T* data)
  {
    if (!m_count) {
      // The count member doesn't exist, meaning that there are no other references
      // The current pointer may exist though, so should be deleted
      _delete_pointer();
    } else {
      unsigned& count = *m_count;
      if (count==1) {
        // The count member can be reused, but the current pointer should be deleted
        _delete_pointer();
      } else if (!count) {
        // The count member is indicating that it will be destructed, so assign a new one
        // for the given object. This might only happen when a pointer is being destructed
        // and the contained object makes a copy of the pointer and then sets it to something.
        // Very tenuous I know, but still it's possible. Whatever, the object should NOT
        // be deleted, as it is probably in the middle of destruction already.
        m_count = simple_ptr_refcount_new();
      } else {
        // Another pointer holds a reference to the current object, so just decrement
        // and create a new counter for the given object (actually, we start out with deferred counters now)
        --count;
        m_count = 0;
      }
    }
    m_pointer = data;
  }

  template <typename T, typename C>
  T* simple_ptr_base<T,C>::pointer(void)
  {
    return m_pointer;
  }

  template <typename T, typename C>
  const T* simple_ptr_base<T,C>::pointer(void) const
  {
    return m_pointer;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // functions to manage counted referencing

  template <typename T, typename C>
  void simple_ptr_base<T,C>::increment(void)
  {
    // we must have a counter allocated before incrementing - this is guaranteed
//    if (!m_count) return;
  	// Do NOT increment a count that has already been decremented to zero
  	// as the object pointed to by this pointer might be in the middle of destruction
  	// This can happen if a callback within the destructor of an object held by this
  	// pointer makes a copy of it's container pointer (this).
  	// The result of incrementing will be that the object gets double-deleted/destructed
  	// which can lead to all sorts of errors as destructors are generally not recursive
  	// A similar check for decrementing is made below
  	// Note that objects are deleted BEFORE the count container is deleted, so the count
  	// container will always be valid in the context of the object.
    unsigned& count = *m_count;
    if (!count) return;
    ++count;
  }

  template <typename T, typename C>
  bool simple_ptr_base<T,C>::decrement(void)
  {
    // if we have never created a counter, then we don't have any other references
    // so return that we should delete our pointer
    if (!m_count) {
    	return true;
    }
    unsigned& count = *m_count;
    // Do NOT destruct if the count is already zero (see increment above)
    if (!count) {
    	return false;
    }
    --count;
    return count == 0;
  }

  template <typename T, typename C>
  void simple_ptr_base<T,C>::_delete_pointer(void)
  {
    if (m_pointer) {
      T* pointer = m_pointer;
      m_pointer = 0;
      delete pointer;
    }
  }

  // make this an alias of the passed object
  template <typename T, typename C>
  void simple_ptr_base<T,C>::alias(const simple_ptr_base<T,C>& r)
  {
    // make it alias-copy safe - this means that I don't try to do the
    // assignment if r is either the same object or an alias of it
    if (m_pointer==r.m_pointer) return;
    if(decrement()) {
      _delete_pointer();
      if (m_count) {
        simple_ptr_refcount_delete(m_count);
      }
    }
    m_pointer = r.m_pointer;
    // deferred count allocation
    if (r.m_count) {
      m_count = r.m_count;
    } else {
      m_count = ((simple_ptr_base<T,C>&)r).m_count = simple_ptr_refcount_new();
    }
    increment();
  }

  template <typename T, typename C>
  bool simple_ptr_base<T,C>::aliases(const simple_ptr_base<T,C>& r) const
  {
    return m_count && (m_count == r.m_count);
  }

  template <typename T, typename C>
  unsigned simple_ptr_base<T,C>::alias_count(void) const
  {
    return m_count ? *m_count : 1;
  }

  template <typename T, typename C>
  void simple_ptr_base<T,C>::clear(void)
  {
    set(0);
  }

  template <typename T, typename C>
  void simple_ptr_base<T,C>::clear_unique(void)
  {
    set(0);	// no difference between clear and clear_unique with the simple_ptr
  }

  template <typename T, typename C>
  void simple_ptr_base<T,C>::make_unique(void) throw(illegal_copy)
  {
    if (!m_count) {
      return;
    }
    unsigned& count = *m_count;
    if (count <= 1) {
      return;
    }
    --count;
    if (m_pointer) m_pointer = C()(*m_pointer);
    m_count = 0;
  }

  template <typename T, typename C>
  void simple_ptr_base<T,C>::copy(const simple_ptr_base<T,C>& data) throw(illegal_copy)
  {
    alias(data);
    make_unique();
  }

  // internal function for distinguishing unique simple_ptr objects
  // used for example in persistence routines

  template <typename T, typename C>
  unsigned* simple_ptr_base<T,C>::_count(void) const
  {
    if (!m_count) {
      ((simple_ptr_base<T,C>*)this)->m_count = simple_ptr_refcount_new();
    }
    return m_count;
  }

  template <typename T, typename C>
  T* simple_ptr_base<T,C>::_pointer(void) const
  {
    return m_pointer;
  }

  template <typename T, typename C>
  void simple_ptr_base<T,C>::_make_alias(T* pointer, unsigned* const& count)
  {
    // make it alias-copy safe - this means that I don't try to do the
    // assignment if r is either the same object or an alias of it
    if (!m_count || m_count != count)
    {
      if(decrement())
      {
        _delete_pointer();
        if (m_count) {
          simple_ptr_refcount_delete(m_count);
        }
      }
      m_pointer = pointer;
      // deferred count allocation
      if (count) {
        m_count = count;
      } else {
        unsigned*& c = (unsigned*&)count;
        m_count = c = simple_ptr_refcount_new();
      }
      increment();
    }
  }


  ////////////////////////////////////////////////////////////////////////////////
  // simple_ptr class
  ////////////////////////////////////////////////////////////////////////////////

#ifdef STLPLUS_MEMBER_TEMPLATES

  template <typename T>
	template <typename T2>
  simple_ptr<T2> simple_ptr<T>::dyn_cast(void) const {
		simple_ptr<T2> rtn;
		T2* p = dynamic_cast<T2*>(this->m_pointer);
		if (p) rtn._make_alias(p, this->m_count);
		return rtn;
	}

  template <typename T>
	template <typename T2>
  simple_ptr<T2> simple_ptr<T>::stat_cast(void) const {
		simple_ptr<T2> rtn;
		T2* p = static_cast<T2*>(this->m_pointer);
		if (p) rtn._make_alias(p, this->m_count);
		return rtn;
	}

  template <typename T>
	template <typename T2>
  simple_ptr<T2> simple_ptr<T>::cast(void) const {
		simple_ptr<T2> rtn;
		T2* p = (T2*)this->m_pointer;
		if (p) rtn._make_alias(p, this->m_count);
		return rtn;
	}

#endif

  ////////////////////////////////////////////////////////////////////////////////
  // simple_ptr_clone class
  ////////////////////////////////////////////////////////////////////////////////

#ifdef STLPLUS_MEMBER_TEMPLATES

  template <typename T>
	template <typename T2>
  simple_ptr_clone<T2> simple_ptr_clone<T>::dyn_cast(void) const {
		simple_ptr_clone<T2> rtn;
		T2* p = dynamic_cast<T2*>(this->m_pointer);
		if (p) rtn._make_alias(p, this->m_count);
		return rtn;
	}

  template <typename T>
	template <typename T2>
  simple_ptr_clone<T2> simple_ptr_clone<T>::stat_cast(void) const {
		simple_ptr_clone<T2> rtn;
		T2* p = static_cast<T2*>(this->m_pointer);
		if (p) rtn._make_alias(p, this->m_count);
		return rtn;
	}

  template <typename T>
	template <typename T2>
  simple_ptr_clone<T2> simple_ptr_clone<T>::cast(void) const {
		simple_ptr_clone<T2> rtn;
		T2* p = (T2*)this->m_pointer;
		if (p) rtn._make_alias(p, this->m_count);
		return rtn;
	}

#endif

  ////////////////////////////////////////////////////////////////////////////////
  // simple_ptr_nocopy class
  ////////////////////////////////////////////////////////////////////////////////

#ifdef STLPLUS_MEMBER_TEMPLATES

  template <typename T>
	template <typename T2>
  simple_ptr_nocopy<T2> simple_ptr_nocopy<T>::dyn_cast(void) const {
		simple_ptr_nocopy<T2> rtn;
		T2* p = dynamic_cast<T2*>(this->m_pointer);
		if (p) rtn._make_alias(p, this->m_count);
		return rtn;
	}

  template <typename T>
	template <typename T2>
  simple_ptr_nocopy<T2> simple_ptr_nocopy<T>::stat_cast(void) const {
		simple_ptr_nocopy<T2> rtn;
		T2* p = static_cast<T2*>(this->m_pointer);
		if (p) rtn._make_alias(p, this->m_count);
		return rtn;
	}

  template <typename T>
	template <typename T2>
  simple_ptr_nocopy<T2> simple_ptr_nocopy<T>::cast(void) const {
		simple_ptr_nocopy<T2> rtn;
		T2* p = (T2*)this->m_pointer;
		if (p) rtn._make_alias(p, this->m_count);
		return rtn;
	}

#endif

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

