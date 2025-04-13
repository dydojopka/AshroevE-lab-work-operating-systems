#!/bin/bash

# Комбинированная обработка изображений ImageMagick 
# Использование: bash convert_and_date.sh [исходная_папка] [выходная_папка]

# Параметры по умолчанию
SOURCE_DIR="${1:-.}"
OUTPUT_DIR="${2:-processed_images_$(date +%Y%m%d)}"

# Настройки сжатия (можно менять)
QUALITY=85                  # Качество (1-100, меньше = сильнее сжатие)
COMPRESSION_RATE=1.5        # Коэффициент сжатия (выше = сильнее сжатие)

# Создаем выходную директорию
mkdir -p "$OUTPUT_DIR" || {
    echo "Ошибка: Невозможно создать выходную папку '$OUTPUT_DIR'" >&2
    exit 2
}

process_image() {
    input_file="$1"
    output_file="$2"
    
    # Получаем дату из EXIF
    exif_date=$(identify -format "%[EXIF:DateTimeOriginal]" "$input_file" 2>/dev/null)
    
    if [ -n "$exif_date" ]; then
        clean_date=$(echo "$exif_date" | sed 's/:/-/g' | cut -d' ' -f1)
        datetime=$(date -d "$clean_date" +"%d.%m.%Y" 2>/dev/null || echo "Неизвестна")
    else
        file_date=$(stat -c %y "$input_file" | cut -d' ' -f1)
        datetime=$(date -d "$file_date" +"%d.%m.%Y" 2>/dev/null || echo "Неизвестна")
    fi
    
    echo "Обработка: $(basename "$input_file") → Дата: $datetime"
    
    convert "$input_file" \
        -gravity SouthEast \
        -pointsize 60 \
        -fill "rgb(255,255,255)" \
        -annotate +10+10 "$datetime" \
        -quality $QUALITY \
        -define jp2:rate=$COMPRESSION_RATE \
        "jp2:$output_file"
}

export -f process_image

find "$SOURCE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | while IFS= read -r -d $'\0' file; do
    rel_path=$(realpath --relative-to="$SOURCE_DIR" "$file")
    output_file="$OUTPUT_DIR/${rel_path%.*}.jp2"
    mkdir -p "$(dirname "$output_file")"
    process_image "$file" "$output_file"
done

# Фиксируем абсолютный путь ДО вывода
FINAL_PATH=$(realpath "$OUTPUT_DIR" 2>/dev/null || echo "$OUTPUT_DIR")

echo "Обработка завершена. Результаты в: $FINAL_PATH"