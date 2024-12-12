<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт до лабораторної роботи 2</b><br/>
"Рекурсія"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"> 
<b>Студент</b>: 
 Чебан Максим КВ-11</p>

<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання
Реалізуйте дві рекурсивні функції, що виконують деякі дії з вхідним(и) списком(-ами), за
можливості/необхідності використовуючи різні види рекурсії. Функції, які необхідно
реалізувати, задаються варіантом (п. 2.1.1). Вимоги до функцій:
1. Зміна списку згідно із завданням має відбуватись за рахунок конструювання нового
списку, а не зміни наявного (вхідного).
2. Не допускається використання функцій вищого порядку чи стандартних функцій
для роботи зі списками, що не наведені в четвертому розділі навчального
посібника.
3. Реалізована функція не має бути функцією вищого порядку, тобто приймати функції
в якості аргументів.
4. Не допускається використання псевдофункцій (деструктивного підходу).
5. Не допускається використання циклів.
Кожна реалізована функція має бути протестована для різних тестових наборів. Тести
мають бути оформленні у вигляді модульних тестів (див. п. 2.3).

## Варіант 8

   1.Написати функцію remove-even-pairs , яка видаляє зі списку кожен третій та
четвертий елементи:
```lisp
CL-USER> (remove-even-pairs '(1 a 2 b 3 c 4))
(1 A 3 C)
```
2.Написати функцію find-deepest-list , яка поверне "найглибший" підсписок з
вхідного списку:
```lisp
CL-USER> (find-deepest-list '(1 2 3 4 5))
(1 2 3 4 5)
CL-USER> (find-deepest-list '(1 (2 (3) 4) 5))
(3)

```

## Лістинг функції remove-even-pairs
```lisp
(defun remove-even-pairs (lst &optional (index 1))
  (cond
    ((null lst) nil)
    ((or (= (mod index 4) 3) (= (mod index 4) 0))
     (remove-even-pairs (cdr lst) (1+ index)))
    (t (cons (car lst) (remove-even-pairs (cdr lst) (1+ index))))))
```
### Тестові набори
```lisp
(defun check-remove-even-pairs (name input expected)
  (format t "~:[FAILED~;PASSED~]... ~a~%"
          (equal (remove-even-pairs input) expected)
          name))

(defun test-remove-even-pairs ()
  (check-remove-even-pairs "test 1.1" '(1 a 2 b 3 c 4) '(1 a 3 c))
  (check-remove-even-pairs "test 1.2" '() '())
  (check-remove-even-pairs "test 1.3" '(1 2 3 4 5 6 7 8 9) '(1 2 5 6 9))
  (check-remove-even-pairs "test 1.4" '(1 2 (2 3) (3 4)) '(1 2)))
```
### Тестування
```lisp
CL-USER> (test-remove-even-pairs)
PASSED... test 1.1
PASSED... test 1.2
PASSED... test 1.3
PASSED... test 1.4
NIL
```
## Лістинг функції find-deepest-list
```lisp
(defun compare-depth (lst depth current-max)
  (if (null lst)
      current-max
      (let ((current (if (listp (car lst))
                         (deepest-sublist-helper (car lst) (1+ depth))
                         nil))) 
        (compare-depth (cdr lst) depth
                       (if (and current
                                (> (car current) (car current-max)))
                           current
                           current-max)))))

(defun deepest-sublist-helper (lst depth)
  (if (atom lst)
      nil 
      (compare-depth lst depth (list depth lst))))  

(defun find-deepest-list (lst)
  (let ((result (deepest-sublist-helper lst 0)))
    (if result
        (cadr result)
        nil)))
```
### Тестові набори
```lisp
(defun check-find-deepest-list (name input expected)
  (format t "~:[FAILED~;PASSED~]... ~a~%"
          (equal (find-deepest-list input) expected)
          name))

(defun test-find-deepest-list ()
  (check-find-deepest-list "test 2.1" '(1 2 3 4 5) '(1 2 3 4 5))
  (check-find-deepest-list "test 2.3" '(1 (2 (3) 4) 5) '(3))
  (check-find-deepest-list "test 2.3" '(a b (c d (e f (g (h i)))))'(h i))
  (check-find-deepest-list "test 2.4" '((1 2) (3 (4 5)) ((6 (7 8)))) '(7 8)))
```
### Тестування
```lisp
(defun check-find-deepest-list (name input expected)
  (format t "~:[FAILED~;PASSED~]... ~a~%"
          (equal (find-deepest-list input) expected)
          name))

(defun test-find-deepest-list ()
  (check-find-deepest-list "test 2.1" '(1 2 3 4 5) '(1 2 3 4 5))
  (check-find-deepest-list "test 2.3" '(1 (2 (3) 4) 5) '(3))
  (check-find-deepest-list "test 2.3" '(a b (c d (e f (g (h i)))))'(h i))
  (check-find-deepest-list "test 2.4" '((1 2) (3 (4 5)) ((6 (7 8)))) '(7 8)))
```

