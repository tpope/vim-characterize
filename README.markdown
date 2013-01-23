# characterize.vim

In Vim, pressing `ga` on a character reveals its representation in decimal,
octal, and hex.  Characterize.vim modernizes this with the following
additions:

* Unicode character names: `U+00A9 COPYRIGHT SYMBOL`
* Vim digraphs (type after `<C-K>` to insert the character): `Co`, `cO`
* [Emoji codes](http://www.emoji-cheat-sheet.com/): `:copyright:`
* HTML entities: `&copy;`

## Installation

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/tpope/vim-characterize.git

## Contributing

See the contribution guidelines for
[pathogen.vim](https://github.com/tpope/vim-pathogen#readme).

## Self-Promotion

Like characterize.vim?  Follow the repository on
[GitHub](https://github.com/tpope/vim-characterize) and vote for it on
[vim.org](http://www.vim.org/scripts/script.php?script_id=4410).  And if
you're feeling especially charitable, follow [tpope](http://tpo.pe/) on
[Twitter](http://twitter.com/tpope) and
[GitHub](https://github.com/tpope).

## License

Copyright © Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
