////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T>
  matrix<T>::matrix(unsigned rows, unsigned cols, const T& fill) throw()
  {
    m_rows = 0;
    m_cols = 0;
    m_data = 0;
    resize(rows,cols,fill);
  }

  template<typename T>
  matrix<T>::~matrix(void) throw()
  {
    for (unsigned row = 0; row < m_rows; row++)
      delete[] m_data[row];
    delete[] m_data;
  }

  template<typename T>
  matrix<T>::matrix(const matrix<T>& r) throw()
  {
    m_rows = 0;
    m_cols = 0;
    m_data = 0;
    *this = r;
  }

  template<typename T>
  matrix<T>& matrix<T>::operator =(const matrix<T>& right) throw()
  {
    // clear the old values
    for (unsigned row = 0; row < m_rows; row++)
      delete[] m_data[row];
    delete[] m_data;
    m_rows = 0;
    m_cols = 0;
    m_data = 0;
    // now reconstruct with the new
    resize(right.m_rows, right.m_cols);
    for (unsigned row = 0; row < m_rows; row++)
      for (unsigned col = 0; col < m_cols; col++)
        m_data[row][col] = right.m_data[row][col];
    return *this;
  }

  template<typename T>
  void matrix<T>::resize(unsigned rows, unsigned cols, const T& fill) throw()
  {
    // a grid is an array of rows, where each row is an array of T
    // a zero-row or zero-column matrix has a null grid
    // TODO - make this exception-safe - new could throw here and that would cause a memory leak
    T** new_grid = 0;
    if (rows && cols)
    {
      new_grid = new T*[rows];
      for (unsigned row = 0; row < rows; row++)
      {
        new_grid[row] = new T[cols];
        // copy old items to the new grid but only within the bounds of the intersection of the old and new grids
        // fill the rest of the grid with the initial value
        for (unsigned col = 0; col < cols; col++)
          if (row < m_rows && col < m_cols)
            new_grid[row][col] = m_data[row][col];
          else
            new_grid[row][col] = fill;
      }
    }
    // destroy the old grid
    for (unsigned row = 0; row < m_rows; row++)
      delete[] m_data[row];
    delete[] m_data;
    // move the new data into the matrix
    m_data = new_grid;
    m_rows = rows;
    m_cols = cols;
  }

  template<typename T>
  unsigned matrix<T>::rows(void) const throw()
  {
    return m_rows;
  }

  template<typename T>
  unsigned matrix<T>::columns(void) const throw()
  {
    return m_cols;
  }

  template<typename T>
  void matrix<T>::erase(const T& fill) throw()
  {
    for (unsigned row = 0; row < m_rows; row++)
      for (unsigned col = 0; col < m_cols; col++)
        insert(row,col,fill);
  }

  template<typename T>
  void matrix<T>::erase(unsigned row, unsigned col, const T& fill) throw(std::out_of_range)
  {
    insert(row,col,fill);
  }

  template<typename T>
  void matrix<T>::insert(unsigned row, unsigned col, const T& element) throw(std::out_of_range)
  {
    if (row >= m_rows) throw std::out_of_range("matrix::insert row");
    if (col >= m_cols) throw std::out_of_range("matrix::insert col");
    m_data[row][col] = element;
  }

  template<typename T>
  const T& matrix<T>::item(unsigned row, unsigned col) const throw(std::out_of_range)
  {
    if (row >= m_rows) throw std::out_of_range("matrix::item row");
    if (col >= m_cols) throw std::out_of_range("matrix::item col");
    return m_data[row][col];
  }

  template<typename T>
  T& matrix<T>::item(unsigned row, unsigned col) throw(std::out_of_range)
  {
    if (row >= m_rows) throw std::out_of_range("matrix::item row");
    if (col >= m_cols) throw std::out_of_range("matrix::item col");
    return m_data[row][col];
  }

  template<typename T>
  const T& matrix<T>::operator()(unsigned row, unsigned col) const throw(std::out_of_range)
  {
    if (row >= m_rows) throw std::out_of_range("matrix::operator() row");
    if (col >= m_cols) throw std::out_of_range("matrix::operator() col");
    return m_data[row][col];
  }

  template<typename T>
  T& matrix<T>::operator()(unsigned row, unsigned col) throw(std::out_of_range)
  {
    if (row >= m_rows) throw std::out_of_range("matrix::operator() row");
    if (col >= m_cols) throw std::out_of_range("matrix::operator() col");
    return m_data[row][col];
  }

  template<typename T>
  void matrix<T>::fill(const T& item) throw()
  {
    erase(item);
  }

  template<typename T>
  void matrix<T>::fill_column(unsigned col, const T& item) throw (std::out_of_range)
  {
    if (col >= m_cols) throw std::out_of_range("matrix::fill_column");
    for (unsigned row = 0; row < m_rows; row++)
      insert(row, col, item);
  }

  template<typename T>
  void matrix<T>::fill_row(unsigned row, const T& item) throw (std::out_of_range)
  {
    if (row >= m_rows) throw std::out_of_range("matrix::fill_row");
    for (unsigned col = 0; col < m_cols; col++)
      insert(row, col, item);
  }

  template<typename T>
  void matrix<T>::fill_leading_diagonal(const T& item) throw()
  {
    for (unsigned i = 0; i < m_cols && i < m_rows; i++)
      insert(i, i, item);
  }

  template<typename T>
  void matrix<T>::fill_trailing_diagonal(const T& item) throw()
  {
    for (unsigned i = 0; i < m_cols && i < m_rows; i++)
      insert(i, m_cols-i-1, item);
  }

  template<typename T>
  void matrix<T>::make_identity(const T& one, const T& zero) throw()
  {
    fill(zero);
    fill_leading_diagonal(one);
  }

  template<typename T>
  void matrix<T>::transpose(void) throw()
  {
    // no gain in manipulating this, since building a new matrix is no less efficient
    matrix<T> transposed(columns(), rows());
    for (unsigned row = 0; row < rows(); row++)
      for (unsigned col = 0; col < columns(); col++)
        transposed.insert(col,row,item(row,col));
    // TODO - avoid an extra copy by swapping the member data here
    *this = transposed;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

