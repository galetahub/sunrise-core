require 'enumerator'

class Array
  def chunk(pieces)
    q, r = length.divmod(pieces)
    (0..pieces).map { |i| i * q + [r, i].min }.enum_cons(2) \
    .map { |a, b| slice(a...b) }
  end
  
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end
  
  def random
    idx = Kernel.rand(size)
    at(idx)
  end
end
