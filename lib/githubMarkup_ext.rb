module GitHub
  module Markup  
		extend self
		@supported = [
			{:name => 'markdown', :exts => %W(md mkdn mdown markdown) },
			{:name => 'textile', :exts => %W(textile) },
			{:name => 'rdoc', :exts => %W(rdoc) },
			{:name => 'rst', :exts => %W(.txt .rst .rest) },
		]  
	
		def supported_ext?(ext)   
			@supported.each do |type|
				return true if type[:exts].include?(ext)
			end          
			return false
		end  
	end
end