function! FufPattern( pattern )

	let s:listener = {}

	function! s:listener.onComplete(item, method)
		exe "/" . a:item
	endfunction

	function! s:listener.onAbort()
		echo "Abort"
	endfunction

	call fuf#callbackitem#launch( '', 0, ">", s:listener, BufferGrep( a:pattern ), "")

endfunction

command! -nargs=1 FufPattern call FufPattern( <q-args> )

function! FufAllFiles( )

	let s:listener = {}

	if !filereadable( ".project_index" )
		echo "Indexing, please try later."
		call ScreenIndexDir()
		return
	endif	   

	function! s:listener.onComplete(item, method)
		exe "edit " . a:item	
	endfunction

	function! s:listener.onAbort()
		echo "Abort"
	endfunction

	let s.project_index = readfile( ".project_index" )

	call fuf#callbackitem#launch( '', 1, ">", s:listener, s.project_index, "")

endfunction



augroup Fufunction
	au!
	au BufEnter *.php command! FufFunction FufPattern ^[ \t]*(public |private |protected )?(static )?(& ?)?(function|class)
	au BufEnter *.rb  command! FufFunction FufPattern ^[ \t]*(def|class|module)
	au BufEnter *.py  command! FufFunction FufPattern ^[ \t]*(def|class)
	au BufEnter *.m   command! FufFunction FufPattern ^- ?\(
	au BufEnter *.h   command! FufFunction FufPattern ^- ?\(
	au BufEnter *.vim command! FufFunction FufPattern ^[ \t]*fun
	au BufEnter *.js  command! FufFunction FufPattern ^[ \t]*function|: ?function|= ?function
	au BufEnter *.clj command! FufFunction FufPattern ^[ \t]*\(defn
	au BufEnter *.el  command! FufFunction FufPattern ^[ \t]*\(defun
augroup END
