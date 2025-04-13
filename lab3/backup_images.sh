#!/bin/bash

# Лабораторная работа №1: Резервное копирование изображений
# Использование: bash backup_images.sh [исходная_папка]

# 1. Проверка аргументов
if [ "$#" -eq 0 ]; then
    source_dir="."
elif [ "$#" -eq 1 ]; then
    source_dir="$1"
else
    echo "Ошибка: Неверное количество аргументов" >&2
    echo "Использование: $0 [исходная_папка]" >&2
    exit 1
fi

# 2. Проверка существования исходной директории
if [ ! -d "$source_dir" ]; then
    echo "Ошибка: Директория '$source_dir' не существует" >&2
    exit 2
fi

# 3. Определение целевой папки для резерва
backup_dir="image_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir" || {
    echo "Ошибка: Невозможно создать папку $backup_dir" >&2
    exit 3
}

# 4. Поиск и копирование файлов с относительными путями
formats=("*.jpg" "*.jpeg" "*.jp2" "*.png" "*.gif" "*.bmp" "*.webp")
echo "Поиск изображений в: $(realpath "$source_dir")"

# Используем базовый путь для обрезки абсолютных путей
base_dir=$(realpath "$source_dir")

find "$source_dir" -type f \( -name "${formats[0]}" \
    $(printf -- "-o -name %s " "${formats[@]:1}") \) \
    -exec sh -c '
        file="$1"
        rel_path=$(realpath --relative-to="$2" "$file")
        mkdir -p "$3/$(dirname "$rel_path")"
        cp "$file" "$3/$rel_path"
    ' sh {} "$base_dir" "$backup_dir" \;

# 5. Проверка результата
count=$(find "$backup_dir" -type f | wc -l)
echo "Резервное копирование завершено!"
echo "Скопировано файлов: $count"
echo "Резервная копия доступна в: $(realpath "$backup_dir")"