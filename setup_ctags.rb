def accept?(message)
  puts "#{message} (y/n)"
  gets.chomp.strip.downcase == 'y'
end

GIT_TEMPLATE_DEST = '~/.git_template/hooks'.freeze
THE_LORDS_DIR = 'https://raw.githubusercontent.com/Lordnibbler/dotfiles/master/git_template/hooks'.freeze

puts 'installing exuberant ctags via homebrew...'
`brew install ctags`

# https://github.com/tpope/gem-ctags
if accept?('Do you want to create ctags for rubygems?')
  puts `gem install gem-ctags`
  puts `gem ctags`
end

# https://github.com/tpope/rbenv-ctags
if accept?('Do you want to create ctags for ruby stdlib?')
  `mkdir -p ~/.rbenv/plugins`
  `git clone git://github.com/tpope/rbenv-ctags.git \
    ~/.rbenv/plugins/rbenv-ctags`
  `rbenv ctags`
end

puts 'creating git hooks for generating ctags on `git init`'
# create a git template directory in home directory
`mkdir -p #{GIT_TEMPLATE_DEST}`
# tell git you want to use this directory to copy "template" files into all new git repos
`git config --global init.templatedir '~/.git_template'`

puts 'getting some cool files from the internet and copying them to your filesystem'
%w(ctags post-checkout post-commit post-merge post-rewrite).each do |hook_file|
  puts `wget -nc #{THE_LORDS_DIR}/#{hook_file} \
    -P #{GIT_TEMPLATE_DEST}`
  `chmod +x #{GIT_TEMPLATE_DEST}/#{hook_file}`
end

# tell git you want to alias a command `git ctags`
`git config --global alias.ctags '!.git/hooks/ctags'`

puts '=' * 80
puts '!!!END OF SCRIPT MESSAGE!!!'
puts '=' * 80
puts "You dun did it. Good job. Now, in each git repo, whenever you merge,
commit, etc., a .tags file will be updated.\n"
puts "* You can run `git init` or `git ctags` to generate this file once right now.\n"
puts "* If you are an Atom user, use `apm install autocomplete-ctags` to unlock
some dope features.\n"
puts '=' * 80
