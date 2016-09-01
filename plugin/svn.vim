function! Stat()
	Scratch
	set filetype=svn
	call append( 0, "--SVN STAT--" )
	call append( 2, system( "stat" ) )	
endfunction

map <LocalLeader>d :vsp<CR>gf:VCSDiff<CR>

