<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт до лабораторної роботи 3</b><br/>
"Конструктивний і деструктивний підходи до роботи зі списками""<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"> 
<b>Студент</b>: 
 Чебан Максим КВ-11</p>

<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання
Реалізуйте алгоритм сортування чисел у списку двома способами: функціонально і
імперативно.
1. Функціональний варіант реалізації має базуватись на використанні рекурсії і
конструюванні нових списків щоразу, коли необхідно виконати зміну вхідного списку.
Не допускається використання: псевдо-функцій, деструктивних операцій, циклів,
функцій вищого порядку або функцій для роботи зі списками/послідовностями, що
використовуються як функції вищого порядку. Також реалізована функція не має
бути функціоналом (тобто приймати на вхід функції в якості аргументів).
2. Імперативний варіант реалізації має базуватись на використанні циклів і
деструктивних функцій (псевдофункцій). Не допускається використання функцій
вищого порядку або функцій для роботи зі списками/послідовностями, що
використовуються як функції вищого порядку. Тим не менш, оригінальний список
цей варіант реалізації також не має змінювати, тому перед виконанням
деструктивних змін варто застосувати функцію copy-list (в разі необхідності).
Також реалізована функція не має бути функціоналом (тобто приймати на вхід
функції в якості аргументів).

Алгоритм, який необхідно реалізувати, задається варіантом (п. 3.1.1). Зміст і шаблон звіту
наведені в п. 3.2.

Кожна реалізована функція має бути протестована для різних тестових наборів. Тести
мають бути оформленні у вигляді модульних тестів (наприклад, як наведено у п. 2.3).

## Варіант 8

   Алгоритм сортування обміном №4 ("шейкерне сортування") за незменшенням.


## Лістинг функції з використанням конструктивного підходу
```lisp
(defun pass-to-right-rec (lst)
  "Recursive traversal from left to right."
  (if (null (cdr lst))
      lst
      (let ((curr (car lst))
            (next (cadr lst)))
        (if (> curr next)
            (cons next (pass-to-right-rec (cons curr (cddr lst))))
            (cons curr (pass-to-right-rec (cdr lst)))))))

(defun pass-to-left-rec (lst)
  "Recursive traversal from right to left."
  (if (null (cdr lst))
      lst
      (let* ((rest (pass-to-left-rec (cdr lst)))
             (curr (car lst))
             (next (car rest)))
        (if (> curr next)
            (cons next (cons curr (cdr rest)))
            (cons curr rest)))))

(defun shaker-sort-rec (lst L R)
  "Recursive sorting algorithm with traversal bounds L and R."
  (if (>= L R)
      lst
      (let ((new-lst (pass-to-right-rec lst)))
        (shaker-sort-rec (pass-to-left-rec new-lst) (1+ L) (1- R)))))

(defun shaker-sort-func (lst)
  "Shaker sort function for the list `lst' implemented in a functional way."
  (shaker-sort-rec lst 0 (1- (length lst))))

```
### Тестові набори та утиліти
```lisp
(defun check-shaker-sort-func (name input expected)
  (format t "~:[FAILED~;PASSED~]... ~a~%"
          (equal (shaker-sort-func input) expected)
          name))

(defun test-shaker-sort-func ()
  (check-shaker-sort-func "test 1.1" '(1 2 3 4 5) '(1 2 3 4 5)) ; already sorted
  (check-shaker-sort-func "test 1.2" '(5 4 3 2 1) '(1 2 3 4 5)) ; reversed list
  (check-shaker-sort-func "test 1.3" '(5 5 4 4 3) '(3 4 4 5 5)) ; duplicates
  (check-shaker-sort-func "test 1.4" '(3 2 5 1 4 3) '(1 2 3 3 4 5)) ; mixed
  (check-shaker-sort-func "test 1.5" '(3) '(3)) ; single element
  (check-shaker-sort-func "test 1.6" '() '())) ; empty list
```
### Тестування
```lisp
CL-USER> (test-shaker-sort-func)
PASSED... test 1.1
PASSED... test 1.2
PASSED... test 1.3
PASSED... test 1.4
PASSED... test 1.5
PASSED... test 1.6
NIL
```
## Лістинг функції з використанням деструктивного підходу
```lisp
(defun shaker-sort-imp (lst)
  "Shaker sort on list `lst' implemented in a functional way."
  (let* ((lst-copy (copy-list lst))
         (N (length lst-copy))
         (L 0)
         (R (- N 1))
         (k 0))
    (loop while (< L R) do
          (loop for i from L below R do
                (when (>= (nth i lst-copy) (nth (+ i 1) lst-copy))
                  (rotatef (nth i lst-copy) (nth (+ i 1) lst-copy))
                  (setf k i)))
          (setf R k)
          (loop for i from (- R 1) downto L do
                (when (>= (nth i lst-copy) (nth (+ i 1) lst-copy))
                  (rotatef (nth i lst-copy) (nth (+ i 1) lst-copy))
                  (setf k i)))
          (setf L (+ k 1)))
    lst-copy))
```
### Тестові набори та утиліти
```lisp
(defun check-shaker-sort-imp (name input expected)
  (format t "~:[FAILED~;PASSED~]... ~a~%"
          (equal (shaker-sort-imp input) expected)
          name))

(defun test-shaker-sort-imp ()
  (check-shaker-sort-imp "test 2.1" '(1 2 3 4 5) '(1 2 3 4 5)) ; already sorted
  (check-shaker-sort-imp "test 2.2" '(5 4 3 2 1) '(1 2 3 4 5)) ; reversed list
  (check-shaker-sort-imp "test 2.3" '(5 5 4 4 3) '(3 4 4 5 5)) ; duplicates
  (check-shaker-sort-imp "test 2.4" '(3 2 5 1 4 3) '(1 2 3 3 4 5)) ; mixed
  (check-shaker-sort-imp "test 2.5" '(3) '(3)) ; single element
  (check-shaker-sort-imp "test 2.6" '() '())) ; empty list
```
### Тестування
```lisp
CL-USER> (test-shaker-sort-imp)
PASSED... test 2.1
PASSED... test 2.2
PASSED... test 2.3
PASSED... test 2.4
PASSED... test 2.5
PASSED... test 2.6
NIL
```


