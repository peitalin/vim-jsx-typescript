
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax file
"
" Language: JSX (JavaScript)
" https://github.com/neoclide/vim-jsx-improve/blob/master/after/syntax/javascript.vim
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" These are the plugin-to-syntax-element correspondences:
"
"   - pangloss/vim-javascript:      jsBlock, jsExpression
"   - jelera/vim-javascript-syntax: javascriptBlock
"   - othree/yajs.vim:              javascriptNoReserved


let s:jsx_cpo = &cpo
set cpo&vim

syntax case match

if exists('b:current_syntax')
  let s:current_syntax = b:current_syntax
  unlet b:current_syntax
endif

if exists('s:current_syntax')
  let b:current_syntax = s:current_syntax
endif

"  <tag></tag>
" s~~~~~~~~~~~e
syntax region jsxRegion
      \ start=+\%(<\|\w\)\@<!<\z([a-zA-Z][a-zA-Z0-9:\-.]*\)+
      \ skip=+<!--\_.\{-}-->+
      \ end=+</\z1\_\s\{-}[^(=>)]>+
      \ end=+>\n*\t*\n*\s*)\@=+
      \ end=+>\n*\t*\n*\s*\(}\n*\t*\s*[a-zA-Z()]\)\@=+
      \ end=+\n\?\s\*,+
      \ end=+\s*,\@=+
      \ end=+\s\+:\@=+
      \ fold
      \ contains=jsBlock,jsxTag,jsxCloseTag,jsxComment,Comment,@Spell
      \ keepend
      \ extend


" matches template strings in jsx `this is a ${string}`
syn region xmlString contained start=+\({[ ]*\zs`[0-9a-zA-Z/:.#!@% ?-_=+]*\|}\zs[0-9a-zA-Z/:.#!@% ?-_+=]*`\)+ end=++ contains=jsBlock,javascriptBlock

" matches jsx Comments: {/* .....  /*}
syn region Comment contained start=+{/\*+ end=+\*/}+ contains=Comment
  \ extend


" <tag id="sample">
" s~~~~~~~~~~~~~~~e
syntax region jsxTag
      \ matchgroup=jsxCloseTag
      \ start=+<[^ }/!?<>"'=:]\@=+
      \ end=+\/\?>+
      \ contained
      \ contains=jsxTagName,jsxAttrib,jsxEqual,jsxString,jsxEscapeJs

" </tag>
" ~~~~~~
syntax region jsxCloseTag
      \ start=+</[^ /!?<>"'=:]\@=+
      \ end=+>+
      \ contained
      \ contains=jsxCloseString

syntax match jsxCloseString
    \ +\w\++
    \ contained

" <!-- -->
" ~~~~~~~~
syntax match jsxComment /<!--\_.\{-}-->/ display

syntax match jsxEntity "&[^; \t]*;" contains=jsxEntityPunct
syntax match jsxEntityPunct contained "[&.;]"

" <tag key={this.props.key}>
"  ~~~
syntax match jsxTagName
    \ +[<]\@<=[^ /!?<>"']\++
    \ contained
    \ display

" <tag key={this.props.key}>
"      ~~~
syntax match jsxAttrib
    \ +[-'"<]\@<!\<[a-zA-Z:_][-.0-9a-zA-Z0-9:_]*\>\(['">]\@!\|$\)+
    \ contained
    \ contains=jsxAttribPunct,jsxAttribHook
    \ display

syntax match jsxAttribPunct +[:.]+ contained display

" <tag id="sample">
"        ~
syntax match jsxEqual +=+ contained display

" <tag id="sample">
"         s~~~~~~e
syntax region jsxString contained start=+"+ end=+"+ contains=jsxEntity,@Spell display

" <tag id='sample'>
"         s~~~~~~e
syntax region jsxString contained start=+'+ end=+'+ contains=jsxEntity,@Spell display

" <tag key={this.props.key}>
"          s~~~~~~~~~~~~~~e
syntax region jsxEscapeJs matchgroup=jsxAttributeBraces
    \ contained
    \ start=+=\@<={+
    \ end=+}\ze\%(\/\|\n\|\s\|>\)+
    \ contains=TOP
    \ keepend
    \ extend

syntax match jsxIfOperator +?+
syntax match jsxElseOperator +:+

syntax cluster jsExpression add=jsxRegion

" highlight def link jsxTagName htmlTagName
highlight def link jsxTagName xmlTagName
" highlight def link jsxCloseTag htmlTag
highlight def link jsxCloseTag xmlEndTag

highlight def link jsxEqual htmlTag
highlight def link jsxString String
highlight def link jsxNameSpace Function
highlight def link jsxComment Error
highlight def link jsxAttrib htmlArg
highlight def link jsxEscapeJs jsxEscapeJs

highlight def link jsxCloseString htmlTagName
highlight def link jsxAttributeBraces htmlTag

let b:current_syntax = 'javascript.jsx'

let &cpo = s:jsx_cpo
unlet s:jsx_cpo


" Prologue; load in XML syntax.
if exists('b:current_syntax')
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif
syn include @XMLSyntax syntax/xml.vim
if exists('s:current_syntax')
  let b:current_syntax=s:current_syntax
endif

" Officially, vim-jsx depends on the pangloss/vim-javascript syntax package
" (and is tested against it exclusively).  However, in practice, we make some
" effort towards compatibility with other packages.
"
" These are the plugin-to-syntax-element correspondences:
"
"   - pangloss/vim-javascript:      jsBlock, jsExpression
"   - jelera/vim-javascript-syntax: javascriptBlock
"   - othree/yajs.vim:              javascriptNoReserved


" JSX attributes should color as JS.  Note the trivial end pattern; we let
" jsBlock take care of ending the region.
syn region xmlString contained start=+\({[ ]*\zs`[0-9a-zA-Z/:.#!@% ?-_=+]*\|}\zs[0-9a-zA-Z/:.#!@% ?-_+=]*`\)+ end=++ contains=jsBlock,javascriptBlock

" JSX child blocks behave just like JSX attributes, except that (a) they are
" syntactically distinct, and (b) they need the syn-extend argument, or else
" nested XML end-tag patterns may end the outer jsxRegion.
" JSX attributes should color as JS.  Note the trivial end pattern; we let
" jsBlock take care of ending the region.
" syn region jsxChild contained start=+\n{\s+ end=+}+ contains=jsBlock,javascriptBlock
"   \ extend
syn region Comment contained start=+{/\*+ end=+\*/}+ contains=Comment
  \ extend
syn region jsxChild contained start=+&+ end=+&+ contains=jsBlock,javascriptBlock
  \ extend


" Highlight JSX regions as XML; recursively match.
"
" Note that we prohibit JSX tags from having a < or word character immediately
" preceding it, to avoid conflicts with, respectively, the left shift operator
" and generic Flow type annotations (http://flowtype.org/).
syn region jsxRegion
  \ contains=@Spell,@XMLSyntax,jsxRegion,jsBlock,jsxChild,javascriptBlock,Comment
  \ start=+\%(<\|\w\)\@<!<\z([a-zA-Z][a-zA-Z0-9:\-.]*\)+
  \ end=+</\z1\_\s\{-}>+
  \ end=+/>+
  \ keepend
  \ extend

" syntax region jsxRegion
"   \ contains=@Spell,@XMLSyntax,jsxRegion,jsxChild,jsBlock,javascriptBlock
"   \ start=+<\z([^ /!?<>="':]\+\)+
"   \ skip=+{/\*\s\_.\{-}\s\*/}+
"   \ end=+</\z1\_\s\{-}[^(=>)]>+
"   \ end=+>\n\?\s*)\@=+
"   \ end=+>\n\?\s*}\@=+
"   \ end=+>;\@=+
"   \ end=+\n\?\s\*,+
"   \ end=+\s*>,\@=+
"   \ end=+\s\+:\@=+
"   \ fold
"   \ keepend
"   \ extend


" Add jsxRegion to the lowest-level JS syntax cluster.
syn cluster jsExpression add=jsxRegion

" Allow jsxRegion to contain reserved words.
syn cluster javascriptNoReserved add=jsxRegion
