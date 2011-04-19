class String
  def is_int?
    self =~ /^[-+]?[0-9]*$/
  end
  
	def no_html
		str = self.dup
		str.gsub!(/<\/?[^>]*>/, '')
		str.strip!
		str.gsub!('&nbsp;', '')
		str
	end
	
	def words_count
		frequencies = Hash.new(0)  
		downcase.scan(/(\w+([-'.]\w+)*)/) { |word, ignore| frequencies[word] += 1 }
		return frequencies
	end
	
	def parameterize(sep = '-')
	  value = Sunrise::Utils::Transliteration.transliterate(self)
    ActiveSupport::Inflector.parameterize(value, sep)
  end
	
	def self.randomize(length = 8)
	  Array.new(length) { (rand(122-97) + 97).chr }.join
	end
end
