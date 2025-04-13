<div align="center">

# Сборник лабораторных работ по курсу “Операционные системы (ОС)”

</div>

Этот репозиторий представляет из себя сборник всех выполненных [лабораторных работ](https://edu.irnok.net/doku.php?id=sys:os "Операционные системы (ОС) 22ХХ ИГУ") по курсу "Операционные системы (ОС)"

### Enjoy 😼✌️

***

## Содержание


1. [Лабораторная работа №1 (gcc, ассемблер, связь процесса и операционной системы, Makefile, git)](#lab1)
2. [Лабораторная №2 - Установка Linux (развертка, bootstraping)](#lab2)
3. [Лабораторная №3a. - Реализация скрипта bash](#lab3)
4. [Лабораторная №4 - Разработка сетевой инфраструктуры для распределенных вычислений](#lab4)

***

## <a id="lab1">Лабораторная работа №1</a>

### <a id="lab1-1">Шаг 1. Исследование компилятора gcc, язык ассемблера. Связь процесса и операционной системы. Makefile, git.

Из имеющихся вариантов:
>1. Вычисление
>    * факториала, чисел Фибоначчи, функции Аккермана, …
>    * определенного интеграла численным методом,
>    * сходящегося ряда для известных функций (sin, cos, exp, ….);
>2. Реализация численного метода
>    * дифференцирования,
>    * решения трансцендентного уравнения (методы Ньютона, Рыбакова, деления отрезка пополам, золотого сечения, простых итераций, …),
>    * решения задачи Коши;
>3. Реализация алгоритма  
>    * Бразенхема (рисование прямой, окружности, общего вида).

Заморачиваться мне тут сильно не хотелось и я просто выбрал первый вариант - *Вычисление факториала*.  

***

Код программы [factorial.cpp](/lab1/factorial.cpp):
```cpp
#include <iostream>

class MathUtils {
public:
    static int factorial(int n) {
        return (n <= 1) ? 1 : n * factorial(n - 1);
    }
};

int main() {
    int num = 5;
    std::cout << "Factorial of " << num << " is " << MathUtils::factorial(num) << std::endl;
    return 0;
}
```

Скомпилировал программу командой ```g++ -S -O2 -masm=intel -o factorial_O2.s factorial.cpp```(второй уровень оптимизации), и изучил скомпилированный [ассемблер код](/lab1/factorial_O2.s):
```ASM
	.file	"factorial.cpp"
	.intel_syntax noprefix
	.text
#APP
	.globl _ZSt21ios_base_library_initv
#NO_APP
	.section	.text._ZNKSt5ctypeIcE8do_widenEc,"axG",@progbits,_ZNKSt5ctypeIcE8do_widenEc,comdat
	.align 2
	.p2align 4
	.weak	_ZNKSt5ctypeIcE8do_widenEc
	.type	_ZNKSt5ctypeIcE8do_widenEc, @function
_ZNKSt5ctypeIcE8do_widenEc:
.LFB1791:
	.cfi_startproc
	mov	eax, esi         ; Просто возвращает переданный символ
	ret                  ; (часть внутренней реализации потоков C++)
	.cfi_endproc
.LFE1791:
	.size	_ZNKSt5ctypeIcE8do_widenEc, .-_ZNKSt5ctypeIcE8do_widenEc
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Factorial of "  ; Строковая константа
.LC1:
	.string	" is "           ; Строковая константа
	.section	.text.unlikely,"ax",@progbits
.LCOLDB2:
	.section	.text.startup,"ax",@progbits
.LHOTB2:
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB2039:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	lea	rsi, .LC0[rip]      ; Загружает адрес строки "Factorial of "
	lea	rdi, _ZSt4cout[rip] ; Загружает адрес cout
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	sub	rsp, 8
	.cfi_def_cfa_offset 32
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT ; Вывод первой строки
	mov	esi, 5            ; Загружает число 5 (исходное значение num)
	mov	rdi, rax          ; Передает поток вывода
	call	_ZNSolsEi@PLT ; Выводит число 5
	lea	rsi, .LC1[rip]    ; Загружает адрес строки " is "
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT ; Вывод разделителя
	mov	esi, 120          ; Загружает результат 5! = 120 (оптимизация!)
	mov	rdi, rax
	call	_ZNSolsEi@PLT ; Выводит результат
	mov	rbx, rax          ; Работа с завершающим переводом строки
	mov	rax, QWORD PTR [rax]
	mov	rax, QWORD PTR -24[rax]
	mov	rbp, QWORD PTR 240[rbx+rax]
	test	rbp, rbp
	je	.L8             ; Обработка ошибки (худший случай)
	cmp	BYTE PTR 56[rbp], 0
	je	.L5             ; Условный переход для обработки флагов
	movsx	esi, BYTE PTR 67[rbp]
.L6:
	mov	rdi, rbx
	call	_ZNSo3putEc@PLT   ; Вывод символа
	mov	rdi, rax
	call	_ZNSo5flushEv@PLT ; Сброс буфера
	add	rsp, 8
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	xor	eax, eax              ; Возврат 0
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.L5:  ; Обработка перевода строки
	.cfi_restore_state
	mov	rdi, rbp
	call	_ZNKSt5ctypeIcE13_M_widen_initEv@PLT
	mov	rax, QWORD PTR 0[rbp]
	mov	esi, 10
	lea	rdx, _ZNKSt5ctypeIcE8do_widenEc[rip]
	mov	rax, QWORD PTR 48[rax]
	cmp	rax, rdx
	je	.L6
	mov	esi, 10
	mov	rdi, rbp
	call	rax
	movsx	esi, al
	jmp	.L6
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.type	main.cold, @function
main.cold:
.LFSB2039:
.L8:  ; Обработка исключения (если не найден локаль)
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	call	_ZSt16__throw_bad_castv@PLT
	.cfi_endproc
.LFE2039:
	.section	.text.startup
	.size	main, .-main
	.section	.text.unlikely
	.size	main.cold, .-main.cold
.LCOLDE2:
	.section	.text.startup
.LHOTE2:
	.ident	"GCC: (GNU) 14.2.1 20250207"
	.section	.note.GNU-stack,"",@progbits
```
Оптимизации(-O2) можно легко заметить по отсутствию вызова рекурсивной функции ```factorial()```. Компилятор вычислил 5! = 120 на этапе компиляции (константная прогонка) и подставил готовое значение 120 напрямую в код (инструкция ```mov esi, 120```).

Компилятор выполнил агрессивную оптимизацию, полностью устранив вычисления и оставив только необходимые операции ввода-вывода.

***

Выполняя этот подпункт [первого шага](#lab1-1):
> * Преобразовать программу в модульную, разработать Makefile.

Я создал следующую структуру [проекта](/lab1/project1):
```
project1/
├── include/
│   └── math_utils.hpp    # Заголовочный файл
├── src/
│   ├── math_utils.cpp    # Реализация факториала
│   └── main.cpp          # Главная программа
└── Makefile              # Файл сборки
```
#### include/math_utils.hpp:
```hpp
#ifndef MATH_UTILS_HPP
#define MATH_UTILS_HPP

class MathUtils {
public:
    static int factorial(int n); // Объявление метода
};

#endif
```
#### src/math_utils.cpp:
```cpp
#include <iostream>
#include "math_utils.hpp" // Подключаение заголовока

int main() {
    int num = 5;
    std::cout << "Factorial of " << num << " is " 
              << MathUtils::factorial(num) << std::endl;
    return 0;
}
```
#### src/math_utils.cpp:
```cpp
#include "../include/math_utils.hpp"

int MathUtils::factorial(int n) {
    return (n <= 1) ? 1 : n * factorial(n - 1);
}
```
#### Makefile:
```Makefile
# Компилятор и флаги
CXX := g++
CXXFLAGS := -Wall -Wextra -std=c++17 -Iinclude -O2
TARGET := factorial_app

# Исходные файлы и объекты
SRC_DIR := src
OBJ_DIR := obj
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))

# Правила сборки
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Создание директории для объектных файлов
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Очистка
clean:
	rm -rf $(OBJ_DIR) $(TARGET)

.PHONY: all clean
```
* Заголовки в include/ отделены от исходников
* Объектные файлы собираются в отдельную папку obj/
* Флаги компиляции:  
    * ```-std=c++17``` - Современный стандарт C++
    * ```-Iinclude ``` - Путь к заголовочным файлам
    * ```-O2 ``` - Уровень оптимизации
* Автоматизация:
    * wildcard и patsubst автоматически находят все .cpp файлы
    * Правило $(OBJ_DIR) создаёт папку для объектных файлов

Ну и сборка из папки проекта:  
* Сборка - ```make```
* Запуск - ```./factorial_app``` 
* Для очистки - ```make clean```

***

### <a id="lab1-2">Шаг2. Усовершенствовать программу 

Во второй части этой лабораторной требовалось усовершенствовать программу из первого [шага](#lab1-1):

> Добавить параллельный процесс средствами Linux/Windows.   
> Синхронизация доступа к общему ресурсу (файл, канал, pipe, очередь, mmap, smmem). 

Выполняя второй шаг, я модифицировал [проект](/lab1/project2). Теперь он имеет следующую структуру:
```
project2/
├── include/
│   ├── math_utils.hpp    # Заголовочный файл
│   └── shared_utils.hpp  # Новый заголовок для работы с shmem и семафорами
├── src/
│   ├── math_utils.cpp    # Реализация факториала (без изменений)
│   ├── shared_utils.cpp  # Новый модуль для работы с разделяемой памятью
│   └── main.cpp          # Главная программа (модифицирована)
└── Makefile              # Обновлён для поддержки многопроцессности
```

#### include/shared_utils.hpp:
```cpp
#ifndef SHARED_UTILS_HPP
#define SHARED_UTILS_HPP

#include <semaphore.h>

struct SharedData {
    int value;            // Разделяемая ячейка данных
    sem_t write_sem;      // Семафор записи
    sem_t read_sem;       // Семафор чтения
};

void setup_shared_memory(SharedData** shared, const char* name);
void cleanup_shared_memory(SharedData* shared, const char* name);

#endif
```
#### src/main.cpp:
```cpp
#include <iostream>
#include <sys/wait.h>
#include "math_utils.hpp"
#include "shared_utils.hpp"

int main() {
    const char* SHMEM_NAME = "/fact_shmem";
    SharedData* shared = nullptr;

    setup_shared_memory(&shared, SHMEM_NAME);

    pid_t pid = fork();
    if (pid == -1) {
        perror("fork failed");
        return 1;
    }

    if (pid > 0) {  // Родительский процесс
        sem_wait(&shared->write_sem);  // Захватываем семафор записи
        shared->value = 5;             // Пишем значение
        std::cout << "[Parent] Wrote value: " << shared->value << std::endl;
        sem_post(&shared->read_sem);  // Разрешаем чтение

        wait(nullptr);                 // Ждём завершения ребёнка
        cleanup_shared_memory(shared, SHMEM_NAME);
    } 
    else {          // Дочерний процесс
        sem_wait(&shared->read_sem);   // Ждём разрешения на чтение
        int n = shared->value;         // Читаем значение
        std::cout << "[Child] Factorial of " << n 
                  << " is " << MathUtils::factorial(n) << std::endl;
        sem_post(&shared->write_sem);  // Освобождаем для следующей записи
        exit(0);
    }

    return 0;
}
```
#### Makefile:
```makefile
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -pthread -Iinclude
TARGET = factorial_app
SRC_DIR = src
OBJ_DIR = obj

SRCS = $(wildcard $(SRC_DIR)/*.cpp)
OBJS = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ -lrt  # Добавлена линковка с -lrt

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR) $(TARGET) /dev/shm/*sem* /dev/shm/fact_shmem

.PHONY: all clean
```

***

## <a id="lab2">Лабораторная №2 - Установка Linux</a>

В описании лабораторной было представлено несколько вариантов дистрибутивов Linux для установки:
> * (“начальный уровень”) Debian/Ubuntu при помощи debootstrap;
> * (“средний уровень”) ставим Arch Linux (my favorite distribution) русский перевод (может быть неактуальным!) ;
> * (“продвинутый уровень”) Gentoo/Funtoo;
> * (“продвинутый уровень”) Установка глобального доступа в сеть IPv6 Tunnel brocker;
> * (“уровень 'guru'”) LHS;
> * (“уровень 'dao'”) Arch загрузкой по сети DHCP/TFTP/NFS, можно и другие дистрибутивы использовать.

Я решил выбрать и установить Arch Linux. Если следовать шагам по [wiki](https://wiki.archlinux.org/title/Install_Arch_Linux_from_existing_Linux "Install Arch Linux from existing Linux"), то эта задача не является сильно сложной (хотя местами можно запутаться из-за частых переходов по разделам)

> [!NOTE]
>
> <ins>Обязательно нужно читать English версию!</ins>  
> На Ru версии у меня встречались проблемы из-за устаревшего перевода.  
> Если знание английского языка на уровне близкому к *London is a capital of Great Britain*, то как вариант можно открыть две вкладки ([Ru](https://wiki.archlinux.org/title/Install_Arch_Linux_from_existing_Linux_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)) и [En](https://wiki.archlinux.org/title/Install_Arch_Linux_from_existing_Linux) версии) в двух окнах и читать их параллельно. 😉

Процесс установки я записал и загрузил по [ссылке](https://youtu.be/aL9FrlRUXXg?si=sz8vPl8NlZ196cB0)<img src="https://cdn-icons-png.flaticon.com/128/1384/1384060.png" height=15 />: 

[![лаб2. Установка Linux](https://img.youtube.com/vi/aL9FrlRUXXg/maxresdefault.jpg)](https://youtu.be/aL9FrlRUXXg?si=fkoe6XkvyaEYKdrE "youtube.com")

***

## <a id="lab3">Лабораторная №3a. - Реализация скрипта bash</a>

Эта работа подразумевает реализация bash скрипта по заданию из [методички](https://github.com/eugeneai/bash-essentials-ru-handbok/blob/master/bash-ru.pdf "Ускоренный курс элементарного Bash") внутри установленной виртуальной машины из [лабораторной №2](#lab2).

> Студенту для достижения цели необходимо решит следующие задачи:
> 1. Выбрать вариант задания, исходя из собственных предпочтений или опыта,
> 2. Разработать стратегию решения задачи (общий вид алгоритма),
> 3. Выбрать, при необходимости установить, утилиты, решающие конкретные задачи, и ознакомиться с документацией по их использованию;
> 4. Реализовать сценарий;
> 5. Провести тестирование на соответствующих объектах файловой системы (файлах, каталогах);
> 6. Подготовить отчет.

Я решил выполнить первые 3 варианта задания из методички и при этом скомбинировать 2й и 3й вариант.

Пользуясь материалом из той же [методички](https://github.com/eugeneai/bash-essentials-ru-handbok/blob/master/bash-ru.pdf "Ускоренный курс элементарного Bash") и используя свои навыки *продвинутого пользователя интернета*😉 я смог выполнить эти задачи.

***

### <a id="lab3-1">1. Задание №1

> 1. Скопировать из папки все изображения в папку резервного хранения.

***

#### Общий вид алгоритма:
1. Программа может запускаться как с аргументами, так и без них:
	* Без аргументов программа будет выполнять поиск и копирование изображений из текущей дериктории и поддиректориях.
	* С аргументом(путь до папки) программа будет выпонять те же действия но из заданной пользователем директории.
2. Праграмма будет иметь проверки на верность аргументов.
3. Будет создаваться папка под резервное копирование с временной меткой, чтобы избежать перезаписи предыдущих резервных копий.
4. Поиск файлов по расширениям в текущей директории и поддиректориях.
5. Копирование с сохранением структуры каталогов.
6. По зваершению работы будет выводится отчет о выполнении(кол-во скопированных файлов и путь до папки резервного копирования).

***

#### Реализация сценария:

[Код](/lab3/backup_images.sh) выполняющий задание:
```bash
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
```

Запуск осуществляется следующим образом:
```shell
bash backup_images.sh [исходная_папка]
```

***

#### <a id="lab3-1-test">Тестирование:

Я зарание подготовил изображения ```.jpg``` формата и сохранил их на виртуальной машине в ```~/Изображения```.

Так как изображения и [скрипт](/lab3/backup_images.sh) находятся в разных дерикториях я указал аргумент при запуске:  

```shell
bash backup_images.sh /home/user/Изображения
```

![output](/lab3/output-backup_images.sh.png)

Как и было задуманно программа повторяет структуру исходных файлов:
* Исходная папка:  
![original](/lab3/original-images.png)

* Папка резервного копирования:  
![backup](/lab3/backup-images.png)

***

### <a id="lab3-2">2. Задание №2 и №3

> 2. Преобразовать все файлы формата .jpg в формат JPEG2000 при помощи программы convert пакета ImageMagick.
> 3. Добавить в изображения формата .jpg подписи в виде текста даты съемки, дата берется из даты файла изображения, или текущая дата компьютера; изменение изображения делается также программой convert из варианта 2.

***

#### Общий вид алгоритма:

1. Программа может запускаться как с аргументами, так и без них:
	* Если без то будут использоватся параметры по умолчанию  
	```SOURCE_DIR``` — исходная папка (по умолчанию: текущая)  
	```OUTPUT_DIR``` — выходная папка (автоимя по дате)  
	* При использовании пользователем параметров можно указать ```[исходная_папка]``` и ```[выходная_папка]```
2. Программа будет создавать выходную папку под сконвертированные файлы.
3. Будет происходить рекурсивный поиск ```.jpg``` и ```.jpeg``` файлов в ```исходной папке``` и её поддиректориях:  
	1. Получается путь для создания структуры
	2. Извлекается дата из EXIF(случаи с отсутвием даты были учтены).
	3. Накладывается текст и происходит конвертация в ```JPEG2000```(```.jp2```).
	4. Файл сохраняется и происходит повторение действий для остальных файлов.
4. По завершению работы программа выводит путь к папке со всеми созданными файлами.

***

#### Утилиты:

Как и говорилось, в коде будет использоватся программа ```convert``` пакета ```ImageMagick```.

Для начала нужно было его установить:
```shell
sudo -S pacman imagemagick
```

И так же следует изучить [документацию](https://imagemagick.org/ "imagemagick.org") к пакету.

***

#### Реализация сценария:

[Код](/lab3/convert_and_date.sh) выполняющий задание:
```bash
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
```

Запуск осуществляется следующим образом:
```shell
bash convert_and_date.sh [исходная_папка] [выходная_папка]
```

В ходе изучения [документации](https://imagemagick.org/ "imagemagick.org") и написании [кода](/lab3/convert_and_date.sh),
помимо простого получения и добовление на изображение даты из EXIF, а так же конвертации в формат ```JPEG2000```, я:
* Разобрался как выбрать для подписи цвет(```-fill "rgb(255,255,255)"```) и размер(```-pointsize 60```);
* Смог изменить формат вывода даты ```%d.%m.%Y```;
* Добавил простые настройки сжатия качества изображения:
	```bash
	QUALITY=85                  # Качество (1-100, меньше = сильнее сжатие)
	COMPRESSION_RATE=1.5        # Коэффициент сжатия (выше = сильнее сжатие)
	```

***

#### Тестирование:

Для тестирования в качестве исходных изображений я использовал тот же набор файлов что и в [задании №1](#lab3-1-test):

```shell
bash convert_and_date.sh /home/user/Изображения
```

![output](/lab3/output-convert_and_date.sh.png)

> [!NOTE]  
> Судя по содержимому сообщений ```WARNING``` начиная с 7-ой версии ImageMagick вместо программы ```convert``` следует использовать ```magick```.  
> Впрочем на работу программы это никак не повлияло.

* Исходная папка:  
![original](/lab3/original-images.png)

* Папка обработаннх изображений: 
![processed](/lab3/processed-images.png)

Так как формат ```JPEG2000``` не везде поддерживается по стандарту мне пришлось искать программу которая поддерживает просмотр изображений такого формата.
Решением этой проблемы стал пакет [```nomacs```](https://aur.archlinux.org/packages/nomacs "aur.archlinux.org/packages/nomacs").

Количество файлов изображений было довольно большим, поэтому в репозиторий я загрузил далеко не все:

<div align="center">
<table>
<tr>Пример</tr>
<tr><td>До</td><td>После</td></tr><tr><td>
<img src="/lab3/images/ES-room.jpg"/></td><td>
<img src="/lab3/processed_images_20250412/ES-room.jp2"/></td></tr>
<tr><td>До</td><td>После</td></tr><tr><td>
<img src="/lab3/images/bg/mike_room_night.jpg"/></td><td>
<img src="/lab3/processed_images_20250412/bg/mike_room_night.jp2"/></td></tr>
<tr><td>До</td><td>После</td></tr><tr><td>
<img src="/lab3/images/bg/room_mc_night_light.jpg"/></td><td>
<img src="/lab3/processed_images_20250412/bg/room_mc_night_light.jp2"/></td></tr>
<tr><td>До</td><td>После</td></tr><tr><td>
<img src="/lab3/images/bg/school_roof_day_puddle.jpg"/></td><td>
<img src="/lab3/processed_images_20250412/bg/school_roof_day_puddle.jp2"/></td></tr>
<tr><td>До</td><td>После</td></tr><tr><td>
<img src="/lab3/images/bg/tokyo_street_night.jpg"/></td><td>
<img src="/lab3/processed_images_20250412/bg/tokyo_street_night.jp2"/></td></tr>
<tr><td>До</td><td>После</td></tr><tr><td>
<img src="/lab3/images/bg/garden_sunset.jpg"/></td><td>
<img src="/lab3/processed_images_20250412/bg/garden_sunset.jp2"/></td></tr>
</table>
</div>

![jp2](/lab3/processed_images_20250412/ES-room.jp2)


***

## <a id="lab4">Лабораторная №4 - Разработка сетевой инфраструктуры</a>

In progress...

***