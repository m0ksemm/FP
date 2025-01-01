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


 
