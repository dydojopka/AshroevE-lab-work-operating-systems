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
> Преобразовать программу в модульную, разработать Makefile.

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

* Заголовки в include/ отделены от исходников
* Объектные файлы собираются в отдельную папку obj/
* Флаги компиляции:  
    * ```-std=c++17``` - Современный стандарт C++
    * ```-Iinclude ``` - Путь к заголовочным файлам
    * ```-O2 ``` - Уровень оптимизации
* Автоматизация:
    * wildcard и patsubst автоматически находят все .cpp файлы
    * Правило $(OBJ_DIR) создаёт папку для объектных файлов

Ну и сборка проекта из папки проекта:  
* Сборка - ```make```
* Запуск - ```./factorial_app``` 
* Для очистки - ```make clean```

***

### <a id="lab1-2">Шаг2. Усовершенствовать программу 

Выполняя этот подпункт [второго шага](#lab1-2):

Я модифицировал [проект](/lab1/project2), теперь он имеет следующую структуру:
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

In progress...

***

## <a id="lab4">Лабораторная №4 - Разработка сетевой инфраструктуры</a>

In progress...

***