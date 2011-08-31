class Albino 
	
	@supported = [
		{ :names => ['clojure', 'clj'], 
			:exts => ['.clj'], 
			:mime_types => %W(text/x-clojure application/x-clojure) }, 
		{ :names => ['lua'], 
				:exts => %W(.lua .wlua), 
				:mime_types => %W(text/x-lua application/x-lua) },   
		{ :names => %W(perl pl), 
			:exts => %W(.pl .pm), 
			:mime_types => %W(text/x-perl application/x-perl) }, 
		{ :names => %W(python3 py3), 
				:exts => %W(.py3), 
				:mime_types => %W(text/x-python3 application/x-python3) }, 
		{ :names => %W(python py), 
			:exts => %W(.py .pyw .sc), 
			:mime_types => %W(text/x-python application/x-python) }, 
		{ :names => %W(ruby rb duby), 
				:exts => %W(.rb .rbw Rakefile .rake .gemspec .rbx .duby), 
				:mime_types => %W(text/x-ruby application/x-ruby) },   
		{ :names => %W(c), 
			:exts => %W(.c .h), 
			:mime_types => %W(text/x-chdr text/x-csrc) }, 
		{ :names => %W(cpp c++), 
				:exts => %W(.cpp .hpp .c++ .h++ .cc .hh .cxx .hxx), 
				:mime_types => %W(text/x-c++hdr text/x-c++src) },	      
		{ :names => %W(cython pyx), 
			:exts => %W(.pyx .pxd .pxi), 
			:mime_types => %W(text/x-cython application/x-cython) }, 
		{ :names => %W(d), 
				:exts => %W(.d .di), 
				:mime_types => %W(text/x-dsrc) }, 
		{ :names => %W(delphi pas pascal objectpascal), 
			:exts => %W(.pas), 
			:mime_types => %W(text/x-pascal) }, 
		{ :names => %W(go), 
				:exts => %W(.go), 
				:mime_types => %W(text/x-gosrc) },   
		{ :names => %W(java), 
			:exts => %W(.java), 
			:mime_types => %W(text/x-java) }, 
		{ :names => %W(objective-c objectivec obj-c objc), 
				:exts => %W(.m .objc), 
				:mime_types => %W(text/x-objective-c) }, 
		{ :names => %W(csharp c#), 
			:exts => %W(.cs), 
			:mime_types => %W(text/x-csharp) }, 
		{ :names => %W(common-lisp cl), 
				:exts => %W(.cl .lisp .el), 
				:mime_types => %W(text/x-common-lisp) }, 
		{ :names => %W(haskell hs), 
			:exts => %W(.hs), 
			:mime_types => %W(text/x-haskell) }, 
		{ :names => %W(ocaml), 
				:exts => %W(.ml .mli .mll .mlyy), 
				:mime_types => %W(text/x-ocaml) },   
		{ :names => %W(scheme scm), 
			:exts => %W(.scm), 
			:mime_types => %W(text/x-scheme application/x-scheme) }, 
		{ :names => %W(applescript), 
				:exts => %W(.applescript), 
				:mime_types => %W() },	      
		{ :names => %W(bash sh ksh), 
			:exts => %W(.sh .ksh .bash), 
			:mime_types => %W(application/x-sh application/x-shellscript) }, 
		{ :names => %W(mysql sql), 
				:exts => %W(.sql), 
				:mime_types => %W(text/x-mysql) }, 
		{ :names => %W(smalltalk squeak), 
			:exts => %W(.st), 
			:mime_types => %W(text/x-smalltalk) }, 
		{ :names => %W(yaml), 
				:exts => %W(.yaml .yml), 
				:mime_types => %W(text/x-yaml) },   
		{ :names => %W(as actionscript as3 actionscript3), 
			:exts => %W(.as), 
			:mime_types => %W(application/x-actionscript text/x-actionscript text/actionscript) }, 
		{ :names => %W(coffee-script coffeescript), 
				:exts => %W(.coffee), 
				:mime_types => %W(text/coffeescript) },    		
		{ :names => %W(css), 
				:exts => %W(.css), 
				:mime_types => %W(text/css) }, 
		{ :names => %W(haml HAML), 
				:exts => %W(.haml), 
				:mime_types => %W(text/x-haml) }, 
		{ :names => %W(hx haXe), 
			:exts => %W(.hx), 
			:mime_types => %W(text/haxe) }, 
		{ :names => %W(html), 
				:exts => %W(.html .htm .xhtml .xslt), 
				:mime_types => %W(text/html application/xhtml+xml) },   
		{ :names => %W(jade JADE), 
			:exts => %W(.jade), 
			:mime_types => %W(text/x-jade) }, 
		{ :names => %W(js, javascript), 
				:exts => %W(.js), 
				:mime_types => %W(application/javascript application/x-javascript text/x-javascript text/javascript) },	      
		{ :names => %W(objective-j objectivej obj-j objj), 
			:exts => %W(.j), 
			:mime_types => %W(text/x-objective-j) }, 
		{ :names => %W(php php3 php4 php5), 
				:exts => %W(.php .php3 .php4 php5), 
				:mime_types => %W(text/x-php) }, 
		{ :names => %W(sass SASS), 
			:exts => %W(.sass), 
			:mime_types => %W(text/x-sass) }, 
		{ :names => %W(scss), 
				:exts => %W(.scss), 
				:mime_types => %W(text/x-scss) },   
		{ :names => %W(xml), 
			:exts => %W(.xml .xsl .rss .xslt .xsd .wsdl), 
			:mime_types => %W(text/xml application/xml image/svg+xml application/rss+xml application/atom+xml application/xsl+xml application/xslt+xml) }, 
		{ :names => %W(xslt), 
				:exts => %W(.xsl .xslt), 
				:mime_types => %W(text/xml application/xml image/svg+xml application/rss+xml application/atom+xml application/xsl+xml application/xslt+xml) }, 
	]
	 
	def supported_mime?(mimetype) 
		@supported.each do |type|
			return true if type[:mime_types].include?(mimetype)
		end  
		return false
	end  
	
	def mime_to_lang(mimetype) 
		@supported.each do |type|
			return type[:names][0] if type[:mime_types].include?(mimetype)
		end 
		return nil
	end
end