function fish_prompt
    set -l last_status $status

    set -l red (set_color red)
    set -l blue (set_color blue)
    set -l magenta (set_color magenta)
    set -l green (set_color green)
    set -l yellow (set_color yellow)
    set -l white (set_color white)
    set -l normal (set_color normal)

    echo

    set -l left "$red┏[$red󰉋 $normal"
    set -l path_str (pwd | string replace $HOME "~")
    set left "$left$blue$path_str$red]"

    set -l git_branch (command git symbolic-ref --short HEAD 2>/dev/null)
    if test -n "$git_branch"
        set left "$left $red $normal$magenta$git_branch"
    end

    if test $last_status -ne 0
        set left "$left $red󰅚 $normal$white$last_status"
    end

    set left "$left $red󱐋 ꧂"

    set -l extras ""

    set -l diff_stat (command git diff --shortstat 2>/dev/null)
    if test -n "$diff_stat"
        set -l insertions 0
        set -l deletions 0
        set -l parts (string split ", " "$diff_stat")
        for part in $parts
            set -l num (echo "$part" | string match -r '\d+')
            if string match -q -r 'insertion' "$part"
                set insertions $num
            else if string match -q -r 'deletion' "$part"
                set deletions $num
            end
        end
        if test $insertions -gt 0
            set extras "$extras$green󰐕$insertions$normal "
        end
        if test $deletions -gt 0
            set extras "$extras$red󰍴$deletions$normal "
        end
    end

    set -l stash_count (command git stash list 2>/dev/null | count)
    if test $stash_count -gt 0
        set extras "$extras$yellow󰏗 $stash_count$normal "
    end

    if set -q VIRTUAL_ENV
        set extras "$extras$green "(basename "$VIRTUAL_ENV")"$normal "
    else if set -q CONDA_DEFAULT_ENV
        set extras "$extras$green "(basename "$CONDA_DEFAULT_ENV")"$normal "
    else if set -q POETRY_ACTIVE
        set extras "$extras$green poetry$normal "
    end

    set -l jobs_count (jobs -p | wc -l)
    if test $jobs_count -gt 0
        set extras "$extras$yellow󰒲$jobs_count$normal "
    end

    set -l files (command git ls-files --exclude-standard 2>/dev/null | string match -r -v '(\.(json|lock|svg|png|jpg|jpeg|gif|ico|woff2?|ttf|eot|otf|mp[34]|ogg|wav|zip|idx|pack|keep|whl|pyc|class|o|wasm|map|mem|hex|bin|docx?|xlsx?|pptx?|pdf|circ|exe|dll|so|a|deb|rpm)$|(^|/)(node_modules|target|build|dist|vendor|__pycache__|\.next|out|public)/|(^|/)main$)')
    if test -n "$files"
        set -l total (printf "%s\n" $files | xargs -d '\n' wc -l 2>/dev/null | tail -1 | awk '{print $1}')
        if test -n "$total" -a "$total" -gt 0
            set extras "$extras$white󰦨$total$normal "
        end
    end

    set -l cols (tput cols)
    printf "%s" "$left"

    if test -n (string trim "$extras")
        set -l left_len (string length --visible "$left")
        set -l extras_visible (string trim "$extras")
        set -l extras_len (string length --visible "$extras_visible")
        set -l padding (math "max(0, $cols - $left_len - $extras_len - 2)")
        if test $padding -gt 0
            printf "%*s" $padding ""
        end
        set_color red
        printf "["
        set_color normal
        printf "%s" "$extras_visible"
        set_color red
        printf "]"
        set_color normal
    end

    printf "\n"

    set -l host (uname -n | string split "." | head -1)
    set_color red
    printf "┗["
    set_color normal
    printf "%s" (whoami)
    set_color red
    printf "@"
    set_color normal
    printf "%s" $host
    set_color red
    printf "] "
    set_color normal
    printf "> "
end
