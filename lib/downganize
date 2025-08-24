#!/bin/bash

create_dir () {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi
}

sort_file () {
    local file="$1"
    local dir="$HOME/Downloads"

    local siz=$(stat -c %s "$file")

    ext=$(echo "$file" | rev | cut -d '.' -f1 | rev)
    if [ "$siz" -eq 0 ]; then
        return
    fi
    case "$ext" in
        jpg|jpeg|png|gif|bmp)
            create_dir "$dir/Images"
            mv "$file" "$dir/Images/"
            ;;
        mp4|mkv|avi|mov|flv)
            create_dir "$dir/Videos"
            mv "$file" "$dir/Videos/"
            ;;
        mp3|wav|flac|aac|ogg)
            create_dir "$dir/Music"
            mv "$file" "$dir/Music/"
            ;;
        zip|tar|gz|rar|7z)
            create_dir "$dir/Archives"
            mv "$file" "$dir/Archives/"
            ;;
        pdf|doc|docx|txt|odt|ppt|pptx)
            create_dir "$dir/Documents"
            mv "$file" "$dir/Documents/"
            ;;
        deb|rpm|exe|appimage|sh)
            create_dir "$dir/Installers"
            mv "$file" "$dir/Installers/"
            ;;
        part)
            return
            ;;
        *)
            create_dir "$dir/Others"
            mv "$file" "$dir/Others/"
            ;;
    esac
}

downganize () {
    local dir="$HOME/Downloads"
    
    while IFS= read -r file; do
        if [ "$file" ] ; then
            sort_file "$file"
        fi
    done < <(find "$dir" -maxdepth 1 -type f)
}
