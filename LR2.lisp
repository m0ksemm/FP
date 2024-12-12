;Реалізація першої функції
(defun remove-even-pairs (lst &optional (index 1))
  (cond
    ((null lst) nil)
    ((or (= (mod index 4) 3) (= (mod index 4) 0))
     (remove-even-pairs (cdr lst) (1+ index)))
    (t (cons (car lst) (remove-even-pairs (cdr lst) (1+ index))))))

(defun check-remove-even-pairs (name input expected)
  (format t "~:[FAILED~;PASSED~]... ~a~%"
          (equal (remove-even-pairs input) expected)
          name))

(defun test-remove-even-pairs ()
  (check-remove-even-pairs "test 1.1" '(1 a 2 b 3 c 4) '(1 a 3 c))
  (check-remove-even-pairs "test 1.2" '() '())
  (check-remove-even-pairs "test 1.3" '(1 2 3 4 5 6 7 8 9) '(1 2 5 6 9))
  (check-remove-even-pairs "test 1.4" '(1 2 (2 3) (3 4)) '(1 2)))





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

(defun check-find-deepest-list (name input expected)
  (format t "~:[FAILED~;PASSED~]... ~a~%"
          (equal (find-deepest-list input) expected)
          name))

(defun test-find-deepest-list ()
  (check-find-deepest-list "test 2.1" '(1 2 3 4 5) '(1 2 3 4 5))
  (check-find-deepest-list "test 2.3" '(1 (2 (3) 4) 5) '(3))
  (check-find-deepest-list "test 2.3" '(a b (c d (e f (g (h i)))))'(h i))
  (check-find-deepest-list "test 2.4" '((1 2) (3 (4 5)) ((6 (7 8)))) '(7 8)))









