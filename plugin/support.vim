command! D Explore %:h
command! -range -nargs=1 Flop call RFlop( "<args>" )
command! FixNewlines %s///g
command! -range -nargs=1 S call SubSub( "<args>" )
command! -range -nargs=1 Flop S/^(.*?)(\\s*)<args>(\\s*)(.*?)$/\\4\\2<args>\\3\\1
command! ValPhp call ValPhp()

"""" 
function! Selection()
	"return [col("'<"), col("'>")]
	return strpart(getline("."), col("'<") - 1, col("'>") - col("'<") + 1)
endfunction


function! SelectionRange()
	return [col("'<") - 1, col("'>") - 1]
endfunction


function! SubSub( args )
ruby << EOR
	start  = VIM[ %Q{col("'<")} ].to_i - 1
	finish = VIM[ %Q{col("'>")} ].to_i - 1
	args   = VIM[ "a:args" ].split( "/" )
	find = args[1]
	replace = args[2]
	args = args.length > 3 ? args[3] : ""

	method = args =~ /g/ ? "gsub" : "sub"
	find = Regexp.new( find, args =~ /i/ )

	line   = VIM::Buffer.current.line

	line[start..finish] = line[start..finish].send( method, find, replace )
	VIM::Buffer.current.line = line
EOR
endfunction


function! BufferContents()
	return getline(1, "$")
endfunction


function! ArrayGrep( list, pattern )
	return split( StringGrep( join( a:list, "\n" ), a:pattern ), "\n" )
endfunction


function! StringGrep( string, pattern )
	return system( "ruby -e 'print STDIN.read.grep( %r{" . a:pattern . "} )'", a:string )
endfunction


function! BufferGrep( pattern )
	return ArrayGrep( BufferContents(), a:pattern )
endfunction


function! RubyEval( string )
	return system( 'ruby -e "print eval STDIN.read"', a:string )
endfunction


function! IndexDir()
	let g:file_index = split( system( "find -E . -type f -not -regex '.*(svn|git|cvs).*'" ), "\n" )
endfunction


function! ValPhp()
	let s:results = system( "php -l " . expand("%") )
	if match( s:results, "No syntax errors detected" ) != -1
		return
	else
		echo s:results
	endif
endfunction

augroup PhpAuto
	au!
	au BufWritePost *.php ValPhp
augroup END
