# neovim notes:

# Pre installs:

choco install ripgrep
choco install sed
choco install mingw (or try and get clang or VSC++ in path)
choco install Glow (not actually sure if it's in chocolatey)

# Lazy vim/neovim plugins:

mini.surround
neovim-tree
telescope
hop
obsidian
glow
nvim-neoclip
nvim-window-picker
nvim-treesitter/nvim-treesitter
nvim-treesitter/playground
trouble.nvim
telescope-undo
undotree
nvim-spectre
lsp-zero?

folding: https://github.com/kevinhwang91/nvim-ufo#installation
surrounding area with character: mini.surround

# ----- COMMANDS ------

# --- operations:

`u` = undo
`CTRL-R` = redo
`%` = jump to matching bracket pair
`y` = yank/copy
`yy/Y` = yank line
`d/x` = cut
`dd/D` = delete line
`p` = put/paste
`P` = paste before cursor
`a` = append after cursor (goes into INSERT MODE)
`A` = append to end of the line (goes into INSERT MODE)
`gp` = p but puts the cursor after the pasted selection
`gP` = P and puts the cursor after the pasted selection
`g<C-H>` = enter block select mode
`c` = change = cut + enter insert mode
`C` = Change until end of line!
`x` = dl = deletes the character under the cursor
`X` = dh = deletes the character before the cursor
`s` = ch = deletes the character under the cursor and puts you into Insert mode
`S` = Flash Treesitter= selects flashed area | default =deletes the current line from ^, and puts you in insert mode
`~` = switch case for a single character
`g~` = toggle case
`gu` = lowercase
`gU` = uppercase

`>` = shift right
`<` = shift left
`=` = format code
`r{char}` = replace character at cursor with {char}
`gd` = jump to definition
`gD` = jump to Decleration
`gf` = jump to file
`gn` = search forwards and selects match
`gN` = search backwards and selects match
`gI` = goto implementation
`gK` | `K` = show signature help
`gi` = goto last place you left insert mode
`gr` = telescope LSP show references
`gw` = search for word under cursor
`m{a-zA-Z}` = create marker, stored in {a-zA-Z}
`'{a-zA-Z}` = Jump to marker stored in {a-zA-Z}
`H/L` = switch to Prev/Next buffer
`gc{motion|c}` = comment (gcc = comment line)
`J` = merge line below (remove this line's eol)
`.` = repeat last action

# --- place/motions:

`h` = left
`j` = down
`k` = up
`l` = right
`l` = character/character
`s` = sentence
`p` = paragraph
`CTRL-U` = Move half page up
`CTRL-D` = Move half page down
`{line}G` | `{line}gg` = go to {line}
`G` = go to end of file
`gg` = go to start of file
`<line-num>gg` = go to line
`w` = go to next word
`W` = go to next word (whitespace separated)
`b` = go to prev word
`B` = go to prev word (whitespace separated)
`e` = go to word end
`E` = go to word end (whitespace separated)
`ge` = go to word end backwards
`gE` = go to word end backwards (whitespace separated)
`{` = go to next paragraph
`}` = go to prev paragraph
`0` = Moves to the first character of a line
`^` = Moves to the first non-blank character of a line
`$` = Moves to the end of a line | selects line
`g_` = Moves to the non-blank character at the end of a line
`CTRL-D` = lets you move down half a page by scrolling the page
`CTRL-U` = lets you move up half a page also by scrolling

## -- char-type:

`b` = brackets == [;{;];};(;)

# --- COMMAND-AT-PLACE ---

<command><i|a|t><place>
`i` = inside
`a` = around
`t` = to
e.g. : `di"` = will delete inside quotes
: `da"` = will delete inside quotes as well as quotes
: `dt"` = will delete up to quotes

# ----- search (also a motion)----

`/<pattern><enter>` = search forwards
`?<pattern><enter>` = search backwards
`if pattern is empty` = do last search

`-` = search for word at cursor

`#` = search for word at cursor backwards

`n` = go to next result
`N` = go to prev result

`{operation}/<pattern><enter>` = apply operation to search result

# ---- find/move to

`f<char>` = find char
`F<char>` = find char backwards
`t<char>` = move to char
`T<char>` = move to char backwards
`;` = go to next
`,` = go to prev

# ---------- VISUAL MODE ------------

`v` = switch to visual mode at cursor (char mode)
`V` = switch to visual mode at line start (line mode)
Use Visual mode to do operations over a selection:
v{motion}{operation}
{motion} creates the selection
{operation} is acted over it
`d` = delete selection
`y` = copy selection
`p` = paste OVER selection (replacing it!)

# ---- char mode:

commands occur at cursor
e.g. :`vp` = paste at cursor (even if a line selection)
: `Vp` = paste at line

`gn` = extends selection to end of next match
`gN` = extends selection to start of prev match

`t` = <tag></tag> place
`u` = lowercase
`U` = uppercase

# ---------- COPY-PASTE -------------

`y{motion}` = copy selection from motion
`d{motion}` = cut selection from motion

## -- registers:

d/c/y all insert into registers.
`y/c` = " = unnamed register
`a-z` = named registers
`A-Z` = same named registers, but appends to instead of replacing
`0` = yank register (last copied item)
`1-9` = last 9 things cut/deleted

## -- named registers:

`"{a-zA-Z}{y|d|c}{motion}` = d/y/c into named register
`:reg` = see registers
`:reg {register}` = inspect {register}

## -- in INSERT MODE:

`CTRL-R {register}` = pastes the contents of {register}
`P` = paste from default register

# --------- COMMON COMBOS -----------

`c{a|i}w` = change;around|inside;word; at cursor
`ct<char>` = change-until-<char>: replace cursor to char
`y{i|a}<char>` = copy;inside|around; char
`dd{p|P}` = swap lines
`yy{n}{p|P}` = duplicate {n} lines (below|above) (n is optional)
`xp` | `dlp` = swap characters
`%{command}G` = {command} over whole file
`dgg` = delete all lines above (including this one)
`dG` = delete all lines bellow (including this one)
`v{motion}{opt-register}p` = replace selection from register
`vaf` = select function

`]]` = Moves the cursor to the end.
`[[` = Moves the cursor to the start.
`Ctrl+Home` =Displays the top of the text.
`Ctrl+End` = Displays the very end of the text.
`:1` = Jumps to the first line.
`:$` = Moves the cursor to the end of the file.
`1G` = Jumps to the top of the file.

## --------- INSERT MODE -------------

`CTRL-R "` = pastes the contents of the unnamed register
`CTRL-R a` = pastes the contents of register a
`CTRL-R 0` = pastes the contents of the yank register
`gv` = go to visual mode with last selection

# -------- jumps --------

`[{brace char | <X>}` = go to prev {brace char}
`]{brace char| <X>}` = go to next {brace char}
`<X>`:

- `e` = error
- `w` = Warning
- `m` = method start; M = method end
- `s` = misspelled word
- `q` = quickfix item
- `t` = todo comment

# --------- EX COMMANDS -------------

`:e` | `:edit {relative path to file}` = open/create file for editing
`:! {script}` = run {script} on cmd
`:lua {script}` = run {script} in lua
`:w` | `:write` = save file (:w! will force save)
`:q` | `:quit` = close file (:q! will force close)
`:wq` = save and close
`:wa` | `:wall` = save all
`:qa` | `:qall` = close all (:qa! will force close all)
`:wqa` | `:wqall` = save and close all
`:[from,to]{command}{options}` = operate {command} over range [from,to] with {options}

- e.g. : `0,10d a` = cut lines 0-10 into register a

- {from,to} : from/to can be offsets ([0,+2])
  : from/to `$` = eof; . = current line
  : range `'<,'>` = current selection (visual mode)
  : range `%` = whole file
- {command} = y, d, copy|t|co, move|m
  `@:` = repeat last Ex Command
  `@@` = repeat last Ex Command again

`:global` | `:g` = execute Ex command on lines that match a given pattern
`:global!` | `:g!` = execute Ex command on lines that DONT match a given pattern
`:{range}g[lobal]/{pattern}/[cmd]`

# -- SUBSTITUTE

`:{range}s/{pattern}/{substitute}/{flags}`

- `range` = the range to replace in (like above) (% for whole file)
- `pattern` = search pattern for text we want to change
- `substitute` = replacement text

- flags:
  :`g` = global = change all occurances in line
  :`i` = insensitive search
  :`c` = to confirm each match
  :`n` = count occurances

# ------- SPLITS (Windows, Panes, and Tabs)-----

`:sp {relative-path-to-file}` = open file in a horizontal split (current if empty)
`:vsp {relative-path-to-file}` = open file in a vertical split (current if empty)
`CTRL-W S` = open horizontal split (mnemonic Window and Split).
`CTRL-W V` = open vertical split (mnemonic Vertical).
`CTRL-W + h/j/k/l` = move between splits left/down/up/right
`CTRL-W q` = close pane
`CTRL-W o` = close all other panes (mnemonic Only)

# -- Tabs:

`:tabnew` `{file}` = open file in a new tab
`:tabn` `(:tabnext)` = go to next tab
`:tabp` `(:tabprevious)` = go to previous tab
`:tabo` `(:tabonly)` = close all other tabs

# ---- neovim-ufo (folding) ---

`za` = toggle fold
`zo` = open fold
`zc` = close fold

# ---- MULTIPLE CURSORS ----------

`g-<ctrl-H>` = enter block-select mode (i.e mu)

# ---------- MACROS -----------

`q<register>` = start recording macro

`> q` = stop recording macro
`> @<register>` = play macro
`> @@` = replay last macro

# ------- nvim ----

`CTRL-/` = open terminal

# -- mini-surround --

## -- normal mode:

`gzn` = change number of neighbourr lines
`gz{a|d|h|r|f|F}{motion}{char}`
`a` = add
`d` = delete
`h` = highlight
`r` = replace char
`R` = enter replace mode (like pressing insert in a normal editor)
`f` = find | F = find rev
`gza{i|a}{motion}{character}`

## -- visual mode:

`gza{char}`
`?` = prompt for left and right surrounds
`char : ?` = prompt user for left/right surrounds
`: f` = function call
`: t` = tag
`: <bracket>` = balanced brackets
`: all other chars` = new surround char

# ----- GLOW ---

install glow
`<leader>md` = Open Glow Preview

# ------- nvim-neoclip -----

`<leader>p` = open neoclip for default register
: other than "enter" the commands have also need CTRL for insert mode

`> enter|p` = paste
`> c` = copy to default register
`> e` = edit
`> q` = replay
`> d` = delete

# ------- neovim-tree -------

`\#` = fuzzy_sorter

`.` = set_root --NB
`/` = fuzzy_finder
`<` = prev_source
`<2-lmb>` = open
`<bs>` = navigate_up --NB
`<c-x>` = clear_filter
`<cr>` = open --NB
`<esc>` = cancel > = next_source
`?` = show_help
`A` = add_directory --NB
`C` = close_node
`D` = fuzzy_finder_directory
`H` = toggle_hidden
`P` = toggle_preview
`R` = refresh
`S` = open_split
`[g` = prev_git_modified
`]g` = next_git_modified
`a` = add --NB
`c` = copy --NB
`d` = delete --NB
`e` = toggle_auto_expand_width
`f` = filter_on_submit
`l` = focus_preview
`m` = move --NB
`p` = paste_from_clipboard
`q` = close_window
`r` = rename --NB
`s` = open_vsplit --NB
`t` = open_tabnew
`w` = open_with_window_picker
`x` = cut_to_clipboard
`y` = copy_to_clipboard
`z` = close_all_nodes

# -- custom keymaps:

`ctrl/alt+del` = Delete word under cursor
`alt+backspace/d` = Delete Previous Word
`<leader>md` = open Glow
`<leader>p` = open neoclip
`<leader>@` = open neoclip macroscope
`<M-f>` = open :HopPattern
`<M-w>/<leader>wp` = Pick & jump to window
`<C-p>` = open telescope file picker

## -- insert mode:

`<M-p>` = open neoclip in insert mode
`<C-h>` = <C-Left> = Move Cursor to start of Previous Word
`<C-l>` = <C-Right> = Move Cursor to start of Next Word

## --normal mode

`<leader>p` = open neoclip in normal mode
`<CR>` = adds a newline
`<S-h>` = <C-Left> = Move Cursor to start of Previous Word
`<S-l>` = <C-Right> = Move Cursor to start of Next Word

## ---- trouble.nvim

`<leader>x|X` = show warnings

## ------ lazygit

`<leader>g{c|s|g|G}`
`c` = commits
`s` = status
`g|G` = LazyGit (root|cwd)

## ------ telescope-undo

`<leader>r` = open telescope undo
`i` : 
- `<cr>` = yank_additions,
- `<S-cr>` = yank_deletions,
- `<C-cr>` = restore,

`n` : 
- `y` = yank_additions,
- `Y` = yank_deletions,
- `u` = restore,


## ------ undotree

`<leader>Ru` = toggle undotree

## ----- vim-fugitive (for :Git)

`<leader>G` = :Git

## ---- nvim-spectre (find and replace all)

`<leader>H`

## -------- symbols-outline

`<leader>cs`

## neovim-tree mappings:

`gc` = git commit
`ga` = git add
`gd` = git diff

# ------ nvim-treesitter/nvim-treesitter



# ------ nvim-treesitter/playground

:TSPlayground

# TODO:

- https://github.com/Badhi/nvim-treesitter-cpp-tools
- https://github.com/m4xshen/hardtime.nvim
- https://github.com/linux-cultist/venv-selector.nvim

# nvim-cmp

`<C-b>` = scroll up 4
`<C-f>` = scroll down 4
`<C-space>` = complete
`<C-e>` = abort
`<C-y>` = confirm
`<Tab>` = select next item
`<S-Tab>` = select previous item

# vim Regex {pattern}s

## Special char NOT requiring escape

Interpreted as regular expression operator without escaping (escape to match literal)
`\` = Escape next character
`^` = Start-­of-line
`$` = End-of­-line
`.` = Any char
`*` = 0 or more quantifier
`~` = Match last given substitute string
`[...]` = Match range
`[^...]` = Not range

## Special char requiring escape

Interpreted as regular expression operators only when escaped (otherwise will be interpreted as literals).
`\<` = Beginning of a word
`\>` = End of word
`\(...\)` = Group
`\|` = Separate alternative
`\_.` = Any single char or end-of-line
`\+` = 1 or more quantifier
`\=` = 0 or 1 quantifier
`\?` = or or 1 quantifier
`\{n,m}` = n to m quantifier
`\{n}` = n quantifier
`\{n,}` = at least n quantifier
`\{,m}` = 0 to m quantifier

## Replacement

`&` = insert whole matched pattern
`\{n}` = text of nth capture group

## Useful examples

`:g/<pattern>/d_` = delete all lines matching pattern
`s/^.*$\n//` = delete empty lines
`s/<­pattern>/new &/` = Replace pattern by "new <whole matched patter­n>"
`s/<­pattern>/­\=@a/` = Replace pattern by content of register "a"
`s/<­pattern>//gn` = Count nb occurence of pattern
