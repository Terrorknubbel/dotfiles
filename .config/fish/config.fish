set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1

set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""

set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_dirtystate "✚"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"

set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green

function browse
  open (eval $argv)
end

function bind_bang
  switch (commandline -t)[-1]
    case "!"
      commandline -t -- $history[1]
      commandline -f repaint
    case "*"
      commandline -i !
  end
end

function fish_user_key_bindings
  bind ! bind_bang
end

function gcb
  if [ (branch_current) = "master" ]
    git checkout -b $argv[1]
  else
    echo 'Fehler: Du befindest dich nicht im Master Branch!'
  end
end

function creds
  if count $argv > /dev/null
    EDITOR='code --wait' bin/rails credentials:edit --environment $argv[1]
  else
    EDITOR='code --wait' bin/rails credentials:edit --environment production
  end
end

alias lsha 'git show | grep commit | cut -d" " -f2 | head -n 1 | xsel --clipboard --input'

alias branch_current='git branch --show-current'
alias branch_oldest_ancestor='/usr/bin/diff -u (git rev-list --first-parent master | psub) (git rev-list --first-parent HEAD | psub) | sed -ne "s/^ //p" | head -1'
alias branch_log='git log (branch_oldest_ancestor)..HEAD'
alias branch_diff='git diff (branch_oldest_ancestor)..HEAD'
alias branch_files='git diff (branch_oldest_ancestor)..HEAD --diff-filter=ACMR --name-only --oneline'
alias branch_rubocop='branch_files | grep "\.\(rb\|gemspec\)\$" | xargs rubocop --force-exclusion'

alias bitbucket_repo_url='echo https://(git remote -v | grep -oh "bitbucket.org[:/][^ ]\+.git" | head -1 | sed "s/:/\//" | sed "s/\.git\$//")'
alias bitbucket_review_url='echo (bitbucket_repo_url)/branches/compare/(branch_current)%0Dmaster'
alias rl='echo Bitte um \"Review\":(bitbucket_review_url) | xsel --clipboard --input'

alias bitbucket_new_review_url='echo (bitbucket_repo_url)/branch/(branch_current)'
alias bitbucket_oldest_ancestor_review_url='echo (bitbucket_repo_url)/branches/compare/(branch_current)..(branch_oldest_ancestor)'
alias bitbucket_branch_commits_url='echo (bitbucket_repo_url)/commits/branch/(branch_current)'

alias planio='browse https://adigi.planio.de/issues/(branch_current | grep -oh "^[0-9]\+")'
alias planio_url='echo https://adigi.planio.de/issues/(branch_current | grep -oh "^[0-9]\+")'

alias rake='noglob rake'
alias hag='noglob ag --hidden --ignore-case'

alias browse_bbr='browse bitbucket_review_url'
alias copy_bbr='bitbucket_review_url | pbcopy'

alias bbb='browse bitbucket_repo_url'
alias bbbr='browse bitbucket_review_url'
alias bbbc='browse bitbucket_branch_commits_url'
alias bred='browse redmine_url'
alias clear='clear && printf "\033[2J\033[3J\033[1;1H"'

alias bec 'bundle exec cucumber'
alias ber 'bundle exec rspec'
alias notes 'code ~/Schreibtisch/notes.md'
alias oc creds

alias vpn-tiki 'sudo openvpn --config /etc/openvpn/client/tiki-wen.conf'

abbr -a bb browse bitbucket_repo_url
abbr -a bbr browse bitbucket_review_url
abbr -a bbnr browse bitbucket_new_review_url
abbr -a bpl browse planio_url
abbr -a n notes
abbr -a c code .
abbr -a cl clear
abbr -a cdf cd ~/.config/fish/
abbr -a cds cd ~/Projekte/holiday_offer
abbr -a cdvf cd ~/Projekte/vf
abbr -a cdc cd ~/.config/
abbr -a rsf source ~/.config/fish/config.fish

abbr -a ws bin/watch_ecs staging
abbr -a wp bin/watch_ecs production
abbr -a ds bin/deploy staging
abbr -a dp bin/deploy production
abbr -a bdr git push origin --delete
abbr -a bd git branch -d
abbr -a rf bin/rspec_fast
abbr -a rff bin/rspec_fast --fail-fast

abbr -a bb    browse bitbucket_repo_url
abbr -a bbr   browse bitbucket_review_url
abbr -a bbnr  browse bitbucket_new_review_url
abbr -a bpl   browse planio_url
abbr -a n     notes

abbr -a gb    git branch
abbr -a gbx   git branch -d
abbr -a gbX   git branch -D

abbr -a gco   git commit
abbr -a gc    git checkout
abbr -a gcm   git checkout master
abbr -a gcs   git checkout staging

abbr -a gfp   git fetch --prune
abbr -a gpr   git pull --rebase
abbr -a gfr   git pull --rebase --stat

abbr -a gia   git add
abbr -a giA   git add --patch
abbr -a gid   git diff --cached

abbr -a gm    git merge
abbr -a gmm   git merge master
abbr -a gmF   git merge --no-ff
abbr -a gmt   git mergetool

abbr -a gp    git push
abbr -a gpod  git push origin --delete

abbr -a gra   git rebase --abort
abbr -a grc   git rebase --continue
abbr -a grs   git rebase --skip

abbr -a gwC   git clean -f
abbr -a gwd   git diff
abbr -a gws   git status --short

abbr -a rb    ruby
abbr -a rbb   bundle
abbr -a rbbe  bundle exec
abbr -a rbbu  bundle update
abbr -a rt  bundle exec rails db:reset RAILS_ENV=test


abbr -a cop   bundle exec rubocop
abbr -a rc    bundle exec rubocop
abbr -a bss   bin/spring stop
abbr -a q     bin/rails shoryuken:create_queues

abbr rr 'kill-and-restart-rails'

abbr -a bin7rails      bin/rails
abbr -a be             bin/ecs_rails
abbr -a bin7ecs_rails  bin/ecs_rails
abbr -a bin7watch_ecs  bin/watch_ecs
abbr -a bin7rspec      bin/rspec
abbr -a bin7cucumber   bin/cucumber

function kill-and-restart-rails
  set PID (lsof -wni tcp:8443 | tail -n 1 | awk '{print $2}')

  bin/spring stop

  if test -n "$PID"
    kill -9 $PID
    bin/rails s
  else
    bin/rails s
  end
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/wolfgang/miniconda3/bin/conda
    eval /home/wolfgang/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<
alias docker-compose 'docker compose'

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/home/wolfgang.macher@dc.tiki-institut.com/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
