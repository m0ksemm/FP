;Functional method
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




;Imperative method
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
