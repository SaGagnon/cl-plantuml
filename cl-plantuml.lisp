;;;; cl-plantuml.lisp

(in-package #:cl-plantuml)

(defparameter *ssl-private-file* #P"plantuml.key")
(defparameter *ssl-certificate-file* #P"plantuml.crt")

(defun generate-png-from-stream (stream &key (output-file "tmp.png"))
  (let ((cmd (concatenate 'string "java -jar plantuml.jar -pipe > " output-file)))
    (ignore-errors (uiop:run-program cmd :input stream)))
  output-file)

(defun generate-png-from-string (string &rest keys)
  (let ((string-stream (make-string-input-stream string)))
    (apply #'generate-png-from-stream string-stream keys)))

(defun write-binary-to-stream (binary-file out-stream)
  (with-open-file (binary-stream binary-file :element-type '(unsigned-byte 8))
    (loop for byte = (read-byte binary-stream nil nil)
          while byte
          do (write-byte byte out-stream))))

(hunchentoot:define-easy-handler (plantuml :uri "/plantuml" :default-request-type :get) ()
  (setf (hunchentoot:content-type*) "image/png")
  (let* ((payload         (hunchentoot:raw-post-data :force-text t))
         (output-stream   (hunchentoot:send-headers))
         (tmp-png         (generate-png-from-string payload)))
    (write-binary-to-stream tmp-png output-stream)
    (delete-file tmp-png)))

(defun start-server ()
  (hunchentoot:start (make-instance 'hunchentoot:easy-ssl-acceptor
                                    :ssl-privatekey-file  *ssl-private-file*
                                    :ssl-certificate-file *ssl-certificate-file*
                                    :port 9003)))
