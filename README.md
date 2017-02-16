vim-jsx-typescript
=======
There is no indentation bundled with this library, so use:

```
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
```
![alt tag](./screenshot.jpg)


Syntax highlighting and indenting for JSX in Typescript. JSX is a JavaScript syntax
transformer which translates inline XML document fragments into JavaScript
objects.

vim-jsx is _not_ a JavaScript syntax package, so in order to use it, you will
also need to choose a base JS highlighter. [leafgarland/typescript-vim][1] is the
recommended package---it is vim-jsx-typescript's "official" dependency.



Set jsx-tag colors in vimrc:
```
" light blues
hi xmlTagName guifg=#59ACE5
hi xmlTag guifg=#59ACE5

" dark blues
hi xmlEndTag guifg=#2974a1
hi htmlTag guifg=#2974a1
hi htmlEndTag guifg=#2974a1
hi htmlTagName guifg=#2974a1
```


