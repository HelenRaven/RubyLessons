module Each

	 def each_inside(ary, &block)
    ary.each.with_index(1) {|item, index| block.call(item, index)}
  end

end


