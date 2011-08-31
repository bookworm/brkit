module MongoMapperExt
	module ParseMarkDown
		def parse_markdown   
			return if self[:desc_raw].blank?  
			markdown = Redcarpet.new(self[:desc_raw])
			self[:desc] = markdown.to_html    
		end  
	end  
end