<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт до лабораторної роботи 4</b><br/>
"Функції вищого порядку та замикання"<br/>
дисципліни "Вступ до функціонального програмування"
</p>

<p align="right"> 
<b>Студент</b>: 
 Чебан Максим КВ-11</p>

<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання
Завдання складається з двох частин:
1. Переписати функціональну реалізацію алгоритму сортування з лабораторної
роботи 3 з такими змінами:
- використати функції вищого порядку для роботи з послідовностями (де це
доречно);
- додати до інтерфейсу функції (та використання в реалізації) два ключових
параметра: key та test , що працюють аналогічно до того, як працюють
параметри з такими назвами в функціях, що працюють з послідовностями. При
цьому key має виконатись мінімальну кількість разів.
2. Реалізувати функцію, що створює замикання, яке працює згідно із завданням за
варіантом (див. п 4.1.2). Використання псевдо-функцій не забороняється, але, за
можливості, має бути мінімізоване.

## Варіант першої частини (варіант 8)
Алгоритм сортування обміном №4 ("шейкерне сортування") за незменшенням.

## Лістинг реалізації першої частини завдання
```lisp
(defun pass-to-right-rec (lst &key test)
  "Recursive traversal from left to right with a custom test function."
  (if (null (cdr lst))
      lst
      (let ((curr (car lst))
            (next (cadr lst)))
        (if (funcall test (cdr curr) (cdr next))
            (cons next (pass-to-right-rec (cons curr (cddr lst)) :test test))
            (cons curr (pass-to-right-rec (cdr lst) :test test))))))

(defun pass-to-left-rec (lst &key test)
  "Recursive traversal from right to left with a custom test function."
  (if (null (cdr lst))
      lst
      (let* ((rest (pass-to-left-rec (cdr lst) :test test))
             (curr (car lst))
             (next (car rest)))
        (if (funcall test (cdr curr) (cdr next))
            (cons next (cons curr (cdr rest)))
            (cons curr rest)))))

(defun shaker-sort-rec (lst L R &key test)
  "Recursive sorting algorithm with traversal bounds L and R and a custom test function."
  (if (>= L R)
      lst
      (let ((new-lst (pass-to-right-rec lst :test test)))
        (shaker-sort-rec (pass-to-left-rec new-lst :test test) (1+ L) (1- R) :test test))))

(defun shaker-sort (lst &key (key #'identity) (test #'>))
  "Shaker sort function with custom key and test functions."
  (let ((keyed-list (mapcar (lambda (x) (cons x (funcall key x))) lst)))
    (mapcar #'car (shaker-sort-rec keyed-list 0 (1- (length keyed-list)) :test test))))
```
### Тестові набори та утиліти першої частини
```lisp
(defun check-shaker-sort (name input expected &key (key #'identity) (test #'>))
  (let ((result (shaker-sort input :key key :test test)))
    (format t "~:[FAILED~;PASSED~]... ~a~%" 
            (equal result expected) 
            name)
    (when (not (equal result expected))
      (format t "Expected: ~a~%Got: ~a~%~%" expected result))))

(defun test-shaker-sort ()
  ;; Тести за замовчуванням
  (check-shaker-sort "test 1.1" '(2 4 6 8 10) '(2 4 6 8 10))
  (check-shaker-sort "test 1.2" '(7 3 2 9 5 1) '(1 2 3 5 7 9))

  ;; Тести з використанням ключових параметрів
  (check-shaker-sort "test 1.3" '(10 20 30 40) '(40 30 20 10) :test #'<)
  (check-shaker-sort "test 1.4" '(9 7 5 3 1) '(9 7 5 3 1) :test #'<)
  (check-shaker-sort "test 1.5" '(3 -6 2 -8 1) '(1 2 3 -6 -8) :key #'abs)
  (check-shaker-sort "test 1.6" '(-2 3 4 -7 -10) '(-10 -7 4 3 -2) :key #'abs :test #'<))
```
### Тестування першої частини
```lisp
CL-USER> ( test-shaker-sort)
PASSED... test 1.1
PASSED... test 1.2
PASSED... test 1.3
PASSED... test 1.4
PASSED... test 1.5
PASSED... test 1.6
NIL
```
## Варіант другої частини 12
Написати функцію replacer , яка має два основні параметри what і to та два
ключові параметри — test та count . repalcer має повернути функцію, яка при
застосуванні в якості першого аргументу reduce робить наступне: при обході списку з
кінця, кожен елемент списка-аргумента reduce , для якого функція test , викликана з
цим елементом та значенням what , повертає значення t (або не nil ), заміняється
на значення to . Якщо count передане у функцію, заміна виконується count разів.
Якщо count не передане тоді обмежень на кількість разів заміни немає. test має
значення за замовчуванням #'eql . Обмеження, які накладаються на використання
функції-результату replacer при передачі у reduce визначаються розробником (тобто,
наприклад, необхідно чітко визначити, якими мають бути значення ключових параметрів
функції reduce from-end та initial-value ).

```lisp
CL-USER> (reduce (replacer 1 2)
'(1 1 1 4)
:from-end ...
:initial-value ...)
(2 2 2 4)
CL-USER> (reduce (replacer 1 2 :count 2)
'(1 1 1 4)
:from-end ...
:initial-value ...)
(1 2 2 4)
```
## Лістинг реалізованої програми
```lisp
 (defun replacer (what to &key (test #'eql) count)
  "Returns a lambda function that can be used with REDUCE to replace elements (WHAT -> TO) in a list, traversing it from the end.
   Replaces only those elements for which the TEST function (default: #'EQL) returns true,
   up to the limit specified by COUNT (if provided).

 For correct use in the REDUCE function, the following keyword arguments must be specified:
    :FROM-END T (to traverse the list from the end).
    :INITIAL-VALUE '() "
  
  (let ((counter 0))
    (lambda (elem acc)
      (if (and (or (null count)
                   (< counter count))
               (funcall test elem what))
          (progn
            (incf counter)
            (cons to acc))  
          (cons elem acc))))) 
```
### Тестові набори та утиліти
```lisp
(defun check-replacer (name input what to expected &key (test #'eql) count)
  (let ((result (reduce (replacer what to :test test :count count)
                        input
                        :from-end t
                        :initial-value '())))
    (format t "~:[FAILED~;PASSED~]... ~a~%" (equal result expected) name)
    (when (not (equal result expected))
      (format t "Expected: ~a~%Got: ~a~%~%" expected result))))

(defun test-replacer ()
  ;; Тести без ключів
  (check-replacer "Test 2.1" '(1 1 1 4) 1 2 '(2 2 2 4))
  (check-replacer "Test 2.2" '(3 3 3 5) 3 9 '(9 9 9 5))
  (check-replacer "Test 2.3" '(1 2 3 4) 5 0 '(1 2 3 4))

  ;; Тести з count
  (check-replacer "Test 2.4" '(1 1 1 4) 1 2 '(1 2 2 4) :count 2)
  (check-replacer "Test 2.5" '(3 3 3 5) 3 9 '(3 9 9 5) :count 2)
  (check-replacer "Test 2.6" '(1 1 1 1) 1 0 '(1 1 0 0) :count 2)

  ;; Тести з test
  (check-replacer "Test 2.7" '(1 2 3 4) 2 8 '(8 2 3 4) :test #'(lambda (x y) (< x y))) 
  (check-replacer "Test 2.8" '(1 2 3 4) 0 99 '(99 99 99 99) :test #'(lambda (x y) t)))

```
### Тестування
```lisp
CL-USER> (test-replacer)
PASSED... Test 2.1
PASSED... Test 2.2
PASSED... Test 2.3
PASSED... Test 2.4
PASSED... Test 2.5
PASSED... Test 2.6
PASSED... Test 2.7
PASSED... Test 2.8
NIL
```



