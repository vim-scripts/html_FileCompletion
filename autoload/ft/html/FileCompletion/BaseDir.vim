" ft/html/FileCompletion/BaseDir.vim: Auto-discovery of the document root base directory.
"
" DEPENDENCIES:
"   - ingo/fs/traversal.vim autoload script
"
" Copyright: (C) 2012-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.13.003	01-Aug-2013	ingo#fs#traversal#FindLastContainedInUpDir now
"				defaults to the current buffer's directory; omit
"				the argument.
"   1.13.002	31-Jul-2013	Delegate the discovery of the document root to
"				ingo#fs#traversal#FindLastContainedInUpDir().
"   1.10.001	16-May-2012	file creation

function! s:GetDocRootGlob()
    " Allow override of the default glob, but don't require the initialization
    " of the global configuration variable.
    return (exists('g:html_FileCompletion_WithinDocRootGlob') ? g:html_FileCompletion_WithinDocRootGlob : '*.{htm,html,xhtml,asp,gsp,jsp,php}')
endfunction
function! ft#html#FileCompletion#BaseDir#Discover()
    " Traverse directory hierarchy upward until no *.html file is found any more.
    let b:basedir = ingo#fs#traversal#FindLastContainedInUpDir(s:GetDocRootGlob())
endfunction

function! ft#html#FileCompletion#BaseDir#Get()
    if ! exists('b:basedir')
	call ft#html#FileCompletion#BaseDir#Discover()
    endif
    return (exists('b:basedir') ? substitute(substitute(b:basedir, '\\', '/', 'g'), '/$', '', '') : '')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
