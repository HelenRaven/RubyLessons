module Each

	def each_in_ary(ary, &block)
    ary.each.with_index(1) {|item, index| yield(item, index)}
  end

end


