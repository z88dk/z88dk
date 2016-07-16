////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include <iomanip>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // the element stored in the hash

  template<typename K, typename T, typename H, typename E>
  class hash_element
  {
  public:
    master_iterator<hash<K,T,H,E>, hash_element<K,T,H,E> > m_master;
    std::pair<const K, T> m_value;
    hash_element<K,T,H,E>* m_next;
    unsigned m_hash;

    hash_element(const hash<K,T,H,E>* owner, const K& key, const T& data, unsigned hash) :
      m_master(owner,this), m_value(key,data), m_next(0), m_hash(hash)
      {
      }

    hash_element(const hash<K,T,H,E>* owner, const std::pair<const K,T>& value, unsigned hash) :
      m_master(owner,this), m_value(value), m_next(0), m_hash(hash)
      {
      }

    ~hash_element(void)
      {
        m_next = 0;
        m_hash = 0;
      }

    const hash<K,T,H,E>* owner(void) const
      {
        return m_master.owner();
      }

    // generate the bin number from the hash value and the owner's number of bins
    unsigned bin(void) const
      {
        return m_hash % (owner()->m_bins);
      }
  };

  ////////////////////////////////////////////////////////////////////////////////
  // iterator

  // null constructor
  template<typename K, typename T, class H, class E, typename V>
  hash_iterator<K,T,H,E,V>::hash_iterator(void)
  {
  }

  // non-null constructor used from within the hash to construct a valid iterator
  template<typename K, typename T, class H, class E, typename V>
  hash_iterator<K,T,H,E,V>::hash_iterator(hash_element<K,T,H,E>* element) :
    safe_iterator<hash<K,T,H,E>,hash_element<K,T,H,E> >(element->m_master)
  {
  }

  // constructor used to create an end iterator
  template<typename K, typename T, class H, class E, typename V>
  hash_iterator<K,T,H,E,V>::hash_iterator(const hash<K,T,H,E>* owner) :
    safe_iterator<hash<K,T,H,E>,hash_element<K,T,H,E> >(owner)
  {
  }

  template<typename K, typename T, class H, class E, typename V>
  hash_iterator<K,T,H,E,V>::hash_iterator(const safe_iterator<hash<K,T,H,E>, hash_element<K,T,H,E> >& iterator) :
    safe_iterator<hash<K,T,H,E>,hash_element<K,T,H,E> >(iterator)
  {
  }

  // destructor

  template<typename K, typename T, class H, class E, typename V>
  hash_iterator<K,T,H,E,V>::~hash_iterator(void)
  {
  }

  // mode conversions

  template<typename K, typename T, class H, class E, typename V>
  TYPENAME hash_iterator<K,T,H,E,V>::const_iterator hash_iterator<K,T,H,E,V>::constify(void) const
  {
    return hash_iterator<K,T,H,E,const std::pair<const K,T> >(*this);
  }

  template<typename K, typename T, class H, class E, typename V>
  TYPENAME hash_iterator<K,T,H,E,V>::iterator hash_iterator<K,T,H,E,V>::deconstify(void) const
  {
    return hash_iterator<K,T,H,E,std::pair<const K,T> >(*this);
  }

  // increment operator looks for the next element in the table
  // if there isn't one, then this becomes an end() iterator with m_bin = m_bins
  template<typename K, typename T, class H, class E, typename V>
  TYPENAME hash_iterator<K,T,H,E,V>::this_iterator& hash_iterator<K,T,H,E,V>::operator ++ (void)
    throw(null_dereference,end_dereference)
  {
    this->assert_valid();
    if (this->node()->m_next)
      this->set(this->node()->m_next->m_master);
    else
    {
      // failing that, subsequent hash values are tried until either an element is found or there are no more bins
      // in which case it becomes an end() iterator
      hash_element<K,T,H,E>* element = 0;
      unsigned current_bin = this->node()->bin();
      for(current_bin++; !element && (current_bin < this->owner()->m_bins); current_bin++)
        element = this->owner()->m_values[current_bin];
      if (element)
        this->set(element->m_master);
      else
        this->set_end();
    }
    return *this;
  }

  // post-increment is defined in terms of pre-increment
  template<typename K, typename T, class H, class E, typename V>
  TYPENAME hash_iterator<K,T,H,E,V>::this_iterator hash_iterator<K,T,H,E,V>::operator ++ (int)
    throw(null_dereference,end_dereference)
  {
    hash_iterator<K,T,H,E,V> old(*this);
    ++(*this);
    return old;
  }

  // two iterators are equal if they point to the same element
  // both iterators must be non-null and belong to the same table
  template<typename K, typename T, class H, class E, typename V>
  bool hash_iterator<K,T,H,E,V>::operator == (const hash_iterator<K,T,H,E,V>& r) const
  {
    return this->equal(r);
  }

  template<typename K, typename T, class H, class E, typename V>
  bool hash_iterator<K,T,H,E,V>::operator != (const hash_iterator<K,T,H,E,V>& r) const
  {
    return !operator==(r);
  }

  template<typename K, typename T, class H, class E, typename V>
  bool hash_iterator<K,T,H,E,V>::operator < (const hash_iterator<K,T,H,E,V>& r) const
  {
    return this->compare(r) < 0;
  }

  // iterator dereferencing is only legal on a non-null iterator
  template<typename K, typename T, class H, class E, typename V>
  V& hash_iterator<K,T,H,E,V>::operator*(void) const
    throw(null_dereference,end_dereference)
  {
    this->assert_valid();
    return this->node()->m_value;
  }

  template<typename K, typename T, class H, class E, typename V>
  V* hash_iterator<K,T,H,E,V>::operator->(void) const
    throw(null_dereference,end_dereference)
  {
    return &(operator*());
  }

  ////////////////////////////////////////////////////////////////////////////////
  // hash

  // totally arbitrary initial size used for auto-rehashed tables
  static unsigned hash_default_bins = 127;

  // constructor
  // tests whether the user wants auto-rehash
  // sets the rehash point to be a loading of 1.0 by setting it to the number of bins
  // uses the user's size unless this is zero, in which case implement the default

  template<typename K, typename T, class H, class E>
  hash<K,T,H,E>::hash(unsigned bins) :
    m_rehash(bins), m_bins(bins > 0 ? bins : hash_default_bins), m_size(0), m_values(0)
  {
    m_values = new hash_element<K,T,H,E>*[m_bins];
    for (unsigned i = 0; i < m_bins; i++)
      m_values[i] = 0;
  }

  template<typename K, typename T, class H, class E>
  hash<K,T,H,E>::~hash(void)
  {
    // delete all the elements
    clear();
    // and delete the data structure
    delete[] m_values;
    m_values = 0;
  }

  // as usual, implement the copy constructor i.t.o. the assignment operator

  template<typename K, typename T, class H, class E>
  hash<K,T,H,E>::hash(const hash<K,T,H,E>& right) :
    m_rehash(right.m_rehash), m_bins(right.m_bins), m_size(0), m_values(0)
  {
    m_values = new hash_element<K,T,H,E>*[right.m_bins];
    // copy the rehash behaviour as well as the size
    for (unsigned i = 0; i < m_bins; i++)
      m_values[i] = 0;
    *this = right;
  }

  // assignment operator
  // this is done by copying the elements
  // the source and target hashes can be different sizes
  // the hash is self-copy safe, i.e. it is legal to say x = x;

  template<typename K, typename T, class H, class E>
  hash<K,T,H,E>& hash<K,T,H,E>::operator = (const hash<K,T,H,E>& r)
  {
    // make self-copy safe
    if (&r == this) return *this;
    // remove all the existing elements
    clear();
    // copy the elements across - remember that this is rehashing because the two
    // tables can be different sizes so there is no quick way of doing this by
    // copying the lists
    for (hash_iterator<K,T,H,E,const std::pair<const K,T> > i = r.begin(); i != r.end(); ++i)
      insert(i->first, i->second);
    return *this;
  }

  // number of values in the hash
  template<typename K, typename T, class H, class E>
  bool hash<K,T,H,E>::empty(void) const
  {
    return m_size == 0;
  }

  template<typename K, typename T, class H, class E>
  unsigned hash<K,T,H,E>::size(void) const
  {
    return m_size;
  }

  // equality
  template<typename K, typename T, class H, class E>
  bool hash<K,T,H,E>::operator == (const hash<K,T,H,E>& right) const
  {
    // this table is the same as the right table if they are the same table!
    if (&right == this) return true;
    // they must be the same size to be equal
    if (m_size != right.m_size) return false;
    // now every key in this must be in right and have the same data
    for (hash_iterator<K,T,H,E,const std::pair<const K,T> > i = begin(); i != end(); i++)
    {
    	hash_element<K,T,H,E>* found = right._find_element(i->first);
    	if (found == 0) return false;
      if (!(i->second == found->m_value.second)) return false;
//      hash_iterator<K,T,H,E,const std::pair<const K,T> > found = right.find(i->first);
//      if (found == right.end()) return false;
//      if (!(i->second == found->second)) return false;
    }
    return true;
  }

  // set up the hash to auto-rehash at a specific size
  // setting the rehash size to 0 forces manual rehashing
  template<typename K, typename T, class H, class E>
  void hash<K,T,H,E>::auto_rehash(void)
  {
    m_rehash = m_bins;
  }

  template<typename K, typename T, class H, class E>
  void hash<K,T,H,E>::manual_rehash(void)
  {
    m_rehash = 0;
  }

  // the rehash function
  // builds a new hash table and moves the elements (without copying) from the old to the new
  // I store the un-modulused hash value in the element for more efficient rehashing
  // passing 0 to the bins parameter does auto-rehashing
  // passing any other value forces the number of bins

  template<typename K, typename T, class H, class E>
  void hash<K,T,H,E>::rehash(unsigned bins)
  {
    // user specified size: just take the user's value
    // auto calculate: if the load is high, increase the size; else do nothing
    unsigned new_bins = bins ? bins : m_bins;
    if (bins == 0 && m_size > 0)
    {
      // these numbers are pretty arbitrary
      // TODO - make them user-customisable?
      float load = loading();
      if (load > 2.0)
        new_bins = (unsigned)(m_bins * load);
      else if (load > 1.0)
        new_bins = m_bins * 2;
    }
    if (new_bins == m_bins) return;
    // set the new rehashing point if auto-rehashing is on
    if (m_rehash) m_rehash = new_bins;
    // move aside the old structure
    hash_element<K,T,H,E>** old_values = m_values;
    unsigned old_bins = m_bins;
    // create a replacement structure
    m_values = new hash_element<K,T,H,E>*[new_bins];
    for (unsigned i = 0; i < new_bins; i++)
      m_values[i] = 0;
    m_bins = new_bins;
    // move all the old elements across, rehashing each one
    for (unsigned j = 0; j < old_bins; j++)
    {
      while(old_values[j])
      {
        // unhook from the old structure
        hash_element<K,T,H,E>* current = old_values[j];
        old_values[j] = current->m_next;
        // rehash using the stored hash value
        unsigned bin = current->bin();
        // hook it into the new structure
        current->m_next = m_values[bin];
        m_values[bin] = current;
      }
    }
    // now delete the old structure
    delete[] old_values;
  }

  // the loading is the average number of elements per bin
  // this simplifies to the total elements divided by the number of bins

  template<typename K, typename T, class H, class E>
  float hash<K,T,H,E>::loading(void) const
  {
    return (float)m_size / (float)m_bins;
  }

  // remove all elements from the table

  template<typename K, typename T, class H, class E>
  void hash<K,T,H,E>::erase(void)
  {
    // unhook the list elements and destroy them
    for (unsigned i = 0; i < m_bins; i++)
    {
      hash_element<K,T,H,E>* current = m_values[i];
      while(current)
      {
        hash_element<K,T,H,E>* next = current->m_next;
        delete current;
        current = next;
      }
      m_values[i] = 0;
    }
    m_size = 0;
  }

  // test for whether a key is present in the table

  template<typename K, typename T, class H, class E>
  bool hash<K,T,H,E>::present(const K& key) const
  {
  	return _find_element(key) != 0;
  }

  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::size_type hash<K,T,H,E>::count(const K& key) const
  {
    return present() ? 1 : 0;
  }

  // add a key and data element to the table - defined in terms of the general-purpose pair insert function

  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::iterator hash<K,T,H,E>::insert(const K& key, const T& data)
  {
    return insert(std::pair<const K,T>(key,data)).first;
  }

  // insert a key/data pair into the table
  // this removes any old value with the same key since there is no multihash functionality

  template<typename K, typename T, class H, class E>
  std::pair<TYPENAME hash<K,T,H,E>::iterator, bool> hash<K,T,H,E>::insert(const std::pair<const K,T>& value)
  {
    // if auto-rehash is enabled, implement the auto-rehash before inserting the new value
    // the table is rehashed if this insertion makes the loading exceed 1.0
    if (m_rehash && (m_size >= m_rehash)) rehash();
    // calculate the new hash value
    unsigned hash_value_full = H()(value.first);
    unsigned bin = hash_value_full % m_bins;
    bool inserted = true;
    // unhook any previous value with this key
    // this has been inlined from erase(key) so that the hash value is not calculated twice
    hash_element<K,T,H,E>* previous = 0;
    for (hash_element<K,T,H,E>* current = m_values[bin]; current; previous = current, current = current->m_next)
    {
      // first check the full stored hash value
      if (current->m_hash != hash_value_full) continue;

      // next try the equality operator
      if (!E()(current->m_value.first, value.first)) continue;

      // unhook this value and destroy it
      if (previous)
        previous->m_next = current->m_next;
      else
        m_values[bin] = current->m_next;
      delete current;
      m_size--;

      // we've overwritten a previous value
      inserted = false;

      // assume there can only be one match so we can give up now
      break;
    }
    // now hook in a new list element at the start of the list for this hash value
    hash_element<K,T,H,E>* new_item = new hash_element<K,T,H,E>(this, value, hash_value_full);
    new_item->m_next = m_values[bin];
    m_values[bin] = new_item;
    // increment the size count
    m_size++;
    // construct an iterator from the list node, and return whether inserted
    return std::make_pair(hash_iterator<K,T,H,E,std::pair<const K,T> >(new_item), inserted);
  }

  // insert a key with an empty data field ready to be filled in later

  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::iterator hash<K,T,H,E>::insert(const K& key)
  {
    return insert(key,T());
  }

  // remove a key from the table - return true if the key was found and removed, false if it wasn't present

  template<typename K, typename T, class H, class E>
  unsigned hash<K,T,H,E>::erase(const K& key)
  {
    unsigned hash_value_full = H()(key);
    unsigned bin = hash_value_full % m_bins;
    // scan the list for an element with this key
    // need to keep a previous pointer because the lists are single-linked
    hash_element<K,T,H,E>* previous = 0;
    for (hash_element<K,T,H,E>* current = m_values[bin]; current; previous = current, current = current->m_next)
    {
      // first check the full stored hash value
      if (current->m_hash != hash_value_full) continue;

      // next try the equality operator
      if (!E()(current->m_value.first, key)) continue;

      // found this key, so unhook the element from the list
      if (previous)
        previous->m_next = current->m_next;
      else
        m_values[bin] = current->m_next;
      // destroy it
      delete current;
      // remember to maintain the size count
      m_size--;
      return 1;
    }
    return 0;
  }

  // remove an element from the hash table using an iterator (std::map equivalent)
  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::iterator hash<K,T,H,E>::erase(TYPENAME hash<K,T,H,E>::iterator it)
  {
    // work out what the next iterator is in order to return it later
    TYPENAME hash<K,T,H,E>::iterator next(it);
    ++next;
    // we now need to find where this item is - made difficult by the use of
    // single-linked lists which means I have to search through the bin from
    // the top in order to unlink from the list.
    unsigned hash_value_full = it.node()->m_hash;
    unsigned bin = hash_value_full % m_bins;
    // scan the list for this element
    // need to keep a previous pointer because the lists are single-linked
    hash_element<K,T,H,E>* previous = 0;
    for (hash_element<K,T,H,E>* current = m_values[bin]; current; previous = current, current = current->m_next)
    {
      // direct test on the address of the element
      if (current != it.node()) continue;
      // found this iterator, so unhook the element from the list
      if (previous)
        previous->m_next = current->m_next;
      else
        m_values[bin] = current->m_next;
      // destroy it
      delete current;
      current = 0;
      // remember to maintain the size count
      m_size--;
      break;
    }
    return next;
  }

  template<typename K, typename T, class H, class E>
  void hash<K,T,H,E>::clear(void)
  {
    erase();
  }

  // search for a key in the table and return an iterator to it
  // if the search fails, returns an end() iterator

  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::const_iterator hash<K,T,H,E>::find(const K& key) const
  {
  	hash_element<K,T,H,E>* found = _find_element(key);
  	return found ? hash_iterator<K,T,H,E,const std::pair<const K,T> >(found) : end();
//  	return hash_iterator<K,T,H,E,const std::pair<const K,T> >(found ? found : this);
  }

  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::iterator hash<K,T,H,E>::find(const K& key)
  {
  	hash_element<K,T,H,E>* found = _find_element(key);
  	return found ? hash_iterator<K,T,H,E,std::pair<const K,T> >(found) : end();
//  	return hash_iterator<K,T,H,E,std::pair<const K,T> >(found ? found : this);
  }

  // table lookup by key using the index operator[], returning a reference to the data field, not an iterator
  // this is rather like the std::map's [] operator
  // the difference is that I have a const and non-const version
  // the const version will not create the element if not present already, but the non-const version will
  // the non-const version is compatible with the behaviour of the map

  template<typename K, typename T, class H, class E>
  const T& hash<K,T,H,E>::operator[] (const K& key) const throw(std::out_of_range)
  {
    // this const version cannot change the hash, so has to raise an exception if the key is missing
  	hash_element<K,T,H,E>* found = _find_element(key);
    if (!found)
      throw std::out_of_range("key not found in stlplus::hash::operator[]");
    return found->m_value.second;
  }

  template<typename K, typename T, class H, class E>
  T& hash<K,T,H,E>::operator[] (const K& key)
  {
    // this non-const version can change the hash, so creates a new element if the key is missing
  	hash_element<K,T,H,E>* found = _find_element(key);
    return found ? found->m_value.second : insert(key)->second;
  }

  // iterators

  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::const_iterator hash<K,T,H,E>::begin(void) const
  {
    // find the first element
    for (unsigned bin = 0; bin < m_bins; bin++)
      if (m_values[bin])
        return hash_iterator<K,T,H,E,const std::pair<const K,T> >(m_values[bin]);
    // if the hash is empty, return the end iterator
    return end();
  }

  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::iterator hash<K,T,H,E>::begin(void)
  {
    // find the first element
    for (unsigned bin = 0; bin < m_bins; bin++)
      if (m_values[bin])
        return hash_iterator<K,T,H,E,std::pair<const K,T> >(m_values[bin]);
    // if the hash is empty, return the end iterator
    return end();
  }

  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::const_iterator hash<K,T,H,E>::end(void) const
  {
    return hash_iterator<K,T,H,E,const std::pair<const K,T> >(this);
  }

  template<typename K, typename T, class H, class E>
  TYPENAME hash<K,T,H,E>::iterator hash<K,T,H,E>::end(void)
  {
    return hash_iterator<K,T,H,E,std::pair<const K,T> >(this);
  }

  template<typename K, typename T, class H, class E>
  void hash<K,T,H,E>::debug_report(std::ostream& str) const
  {
    // calculate some stats first
    unsigned occupied = 0;
    unsigned min_in_bin = m_size;
    unsigned max_in_bin = 0;
    for (unsigned i = 0; i < m_bins; i++)
    {
      if (m_values[i]) occupied++;
      unsigned count = 0;
      for (hash_element<K,T,H,E>* item = m_values[i]; item; item = item->m_next) count++;
      if (count > max_in_bin) max_in_bin = count;
      if (count < min_in_bin) min_in_bin = count;
    }
    // now print the table
    str << "------------------------------------------------------------------------" << std::endl;
    str << "| size:     " << m_size << std::endl;
    str << "| bins:     " << m_bins << std::endl;
    str << "| loading:  " << loading() << " ";
    if (m_rehash)
      str << "auto-rehash at " << m_rehash << std::endl;
    else
      str << "manual rehash" << std::endl;
    str << "| occupied: " << occupied 
        << std::fixed << " (" << (100.0*(float)occupied/(float)m_bins) << "%)" << std::scientific
        << ", min = " << min_in_bin << ", max = " << max_in_bin << std::endl;
    str << "|-----------------------------------------------------------------------" << std::endl;
    str << "|  bin         0     1     2     3     4     5     6     7     8     9" << std::endl;
    str << "|        ---------------------------------------------------------------";
    for (unsigned j = 0; j < m_bins; j++)
    {
      if (j % 10 == 0)
      {
        str << std::endl;
        str << "| " << std::setw(6) << std::right << (j/10*10) << std::left << " |";
      }
      unsigned count = 0;
      for (hash_element<K,T,H,E>* item = m_values[j]; item; item = item->m_next) count++;
      if (!count)
        str << "     .";
      else
        str << std::setw(6) << std::right << count << std::left;
    }
    str << std::endl;
    str << "------------------------------------------------------------------------" << std::endl;
  }

  // find a key and return the element pointer
  // zero is returned if the find fails
  // this is used internally where iterator usage may not be required (after profiling by DJDM)
  template<typename K, typename T, class H, class E>
  hash_element<K,T,H,E>* hash<K,T,H,E>::_find_element(const K& key) const
  {
    // scan the list for this key's hash value for the element with a matching key
    unsigned hash_value_full = H()(key);
    unsigned bin = hash_value_full % m_bins;
    for (hash_element<K,T,H,E>* current = m_values[bin]; current; current = current->m_next)
    {
      if (current->m_hash == hash_value_full && E()(current->m_value.first, key))
        return current;
    }
    return 0;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

