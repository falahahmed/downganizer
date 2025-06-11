#!/bin/bash

create_dir () {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi
}

downganize () {
    local dir="$HOME/Downloads"
    
    while IFS= read -r file; do
        if [ "$file" ] ; then
            ext=$(echo "$file" | rev | cut -d '.' -f1 | rev)
            ext="${ext,,}"
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
                pdf|doc|docx|txt|odt)
                    create_dir "$dir/Documents"
                    mv "$file" "$dir/Documents/"
                    ;;
                deb|rpm|exe|appimage|sh)
                    create_dir "$dir/Installers"
                    mv "$file" "$dir/Installers/"
                    ;;
                *)
                    create_dir "$dir/Others"
                    mv "$file" "$dir/Others/"
                    ;;
            esac
        fi
    done < <(find "$dir" -maxdepth 1 -type f)
}
