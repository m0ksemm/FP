(defpackage :space-db
  (:use :cl)
  (:export :read-csv :write-csv :select :convert-to-hash :convert-to-alist :print-records))

(in-package :space-db)

;;Розділяє рядок CSV на елементи за заданим роздільником.
(defun split-csv-line (line &optional (delimiter #\,)) 
  (loop with start = 0
        for pos = (position delimiter line :start start)
        collect (subseq line start pos)
        while pos
        do (setf start (1+ pos))))

;;Зчитує CSV-файл і перетворює його у список асоціацій (alist).
(defun read-csv (file-path)
  (with-open-file (in file-path)
    (let ((headers (mapcar #'string-downcase (split-csv-line (read-line in)))))
      (loop for line = (read-line in nil)
            while line
            collect (pairlis headers (split-csv-line line))))))

;;Записує список асоціацій (alist) у CSV-файл.
(defun write-csv (file-path records)
  (with-open-file (out file-path :direction :output :if-exists :supersede)
    (let ((headers (mapcar #'car (first records))))
      (format out "~{~a,~}~%" headers)
      (dolist (record records)
        (format out "~{~a,~}~%" (mapcar (lambda (h) (cdr (assoc h record :test #'equal))) headers))))))

;;Фільтрує записи в CSV-файлі на основі критеріїв.
(defun select (file-path &key filter)
  (let ((records (read-csv file-path)))
    (lambda (&rest args &key)
      (loop for record in records
            when (every (lambda (arg)
                          (equal (cdr (assoc (car arg) record :test #'equal))
                                 (cdr arg)))
                        args)
            collect record))))

;;Перетворює список асоціацій (alist) у хеш-таблицю.
(defun convert-to-hash (alist)
  (let ((hash (make-hash-table :test #'equal)))
    (dolist (pair alist)
      (setf (gethash (car pair) hash) (cdr pair)))
    hash))

;;Перетворює хеш-таблицю у список асоціацій (alist).
(defun convert-to-alist (hash)
  (loop for k being the hash-keys in hash
        using (hash-value v)
        collect (cons k v)))

;;Виводить список асоціацій у консоль.
(defun print-records (records)
  (dolist (record records)
    (format t "~{~a: ~a ~}~%" (loop for (k . v) in record append (list k v)))))

;Тестує функціональність бібліотеки.
(defun test-space-db ()
  (let* ((file-path "space-devices.csv")
         (records (read-csv file-path))
         (first-record (first records)))
    ;; Функція тестування зчитування першого запису
    (assert (assoc "name" first-record :test #'equal))
    (assert (assoc "launch-year" first-record :test #'equal))

    ;; Функція тестування конвертації
    (let* ((hash (convert-to-hash first-record))
           (alist (convert-to-alist hash)))
      (assert (equal (sort alist #'string< :key #'car)
                     (sort first-record #'string< :key #'car))))

    ;; Функція тестування вибірки
    (let ((query (funcall (select file-path) :name "Voyager-1")))
      (assert (every (lambda (rec)
                       (equal (cdr (assoc "name" rec :test #'equal)) "Voyager-1"))
                     query)))

    (format t "All tests passed!~%")))