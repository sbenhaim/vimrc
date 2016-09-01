command! CDFile call ScreenSendCmdVimDir( "Shell", "cd " . expand("%:h") )
command! CDDir call ScreenSendCmdVimDir( "Shell", "cd " . expand("%") )
command! CD call ScreenSendCmdVimDir( "Shell", "cd " . getcwd() )
command! Log call ScreenSelect( "Log" )
command! Shell call ScreenSelect( "Shell" )
command! DB call ScreenSelect( "DB" )
command! Themes call ScreenSelect( "Themes" )
command! KillAmm call ScreenKillAmm()
command! KillIndexing call ScreenKill( "Indexing" )
command! KillTagging call ScreenKill( "Tagging" )

command! -nargs=1 Sack call ScreenCreateAndSendCmd( "'Ack " . <q-args> . "'" , "ack --nogroup " . <q-args> )
command! Tag call ScreenSendCmdVimDir( "Tagging", "tag_files" )
command! ReIndex call ScreenSendCmdVimDir( "Indexing", "find . -regextype posix-extended -type f -not -regex \".*(svn|git|cvs).*\" -and -not -name \"*.swp\" > .project_index" )
command! ProjectDir exe "cd " . g:ProjectDir | Exp .

command! -nargs=1 InitAmmScreens call InitAmmScreens( <q-args> )

function! InitAmmScreens( amm )
	let g:ScreenSession=a:amm
	let g:ProjectDir = getcwd()
	call ScreenCreateAndSendCmd( "Log", "bin/tail_php_log.sh" )
	call ScreenCreateAndSendCmd( "DB", "bin/open_db.sh" )
	call ScreenCreateAndSendCmd( "Themes", "cd ../" . a:amm . ".sites.dev.clockwork.net/themes/"  )
	call ScreenCreateAndSendCmd( "Shell", "ls -la" )
	call ScreenCreateAndSendCmd( "Tagging", "tag_files" )
	call ScreenCreateAndSendCmd( "Indexing", "find . -regextype posix-extended -type f -not -regex \".*(svn|git|cvs).*\" -and -not -name \"*.swp\" > .project_index" )
	call ScreenSelect( "Vim" )
endfunction


function! ScreenKillAmm()
	for name in ["Log", "DB", "Themes", "Shell", "Tagging", "Indexing", "Vim"]
		call ScreenKill( name )
	endfor
endfunction

function! Kill( screen )
	call system("screen -p " . a:screen . " -X kill")
endfunction

function! ScreenCreateAndSendCmd( name, args )
	call ScreenCreate( a:name )
	call ScreenSendCmdVimDir( a:name, a:args )
endfunction


function! ScreenSelect( name )
	call system("screen -X select " . a:name )
endfunction

function! ScreenCreate( name )
	call system("screen -X screen -t " . a:name)
endfunction

function! ScreenSendCmd( name, cmd, dir )
	call system("screen -X select -")
	call system("screen -p " . a:name . " -X stuff 'cd " . a:dir . " &&  " . a:cmd . "\n'" )
	call ScreenSelect( a:name )
endfunction

function! ScreenSendCmdVimDir( name, cmd )
	call ScreenSendCmd( a:name, a:cmd, g:ProjectDir )
endfunction


augroup Screen
	au!
	"au BufEnter *	CDFile
augroup END
