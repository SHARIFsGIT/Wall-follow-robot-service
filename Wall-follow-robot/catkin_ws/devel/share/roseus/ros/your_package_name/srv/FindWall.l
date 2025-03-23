;; Auto-generated. Do not edit!


(when (boundp 'your_package_name::FindWall)
  (if (not (find-package "YOUR_PACKAGE_NAME"))
    (make-package "YOUR_PACKAGE_NAME"))
  (shadow 'FindWall (find-package "YOUR_PACKAGE_NAME")))
(unless (find-package "YOUR_PACKAGE_NAME::FINDWALL")
  (make-package "YOUR_PACKAGE_NAME::FINDWALL"))
(unless (find-package "YOUR_PACKAGE_NAME::FINDWALLREQUEST")
  (make-package "YOUR_PACKAGE_NAME::FINDWALLREQUEST"))
(unless (find-package "YOUR_PACKAGE_NAME::FINDWALLRESPONSE")
  (make-package "YOUR_PACKAGE_NAME::FINDWALLRESPONSE"))

(in-package "ROS")





(defclass your_package_name::FindWallRequest
  :super ros::object
  :slots ())

(defmethod your_package_name::FindWallRequest
  (:init
   (&key
    )
   (send-super :init)
   self)
  (:serialization-length
   ()
   (+
    0
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;;
   self)
  )

(defclass your_package_name::FindWallResponse
  :super ros::object
  :slots (_wallfound ))

(defmethod your_package_name::FindWallResponse
  (:init
   (&key
    ((:wallfound __wallfound) nil)
    )
   (send-super :init)
   (setq _wallfound __wallfound)
   self)
  (:wallfound
   (&optional (__wallfound :null))
   (if (not (eq __wallfound :null)) (setq _wallfound __wallfound)) _wallfound)
  (:serialization-length
   ()
   (+
    ;; bool _wallfound
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; bool _wallfound
       (if _wallfound (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; bool _wallfound
     (setq _wallfound (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(defclass your_package_name::FindWall
  :super ros::object
  :slots ())

(setf (get your_package_name::FindWall :md5sum-) "66229cd821efb4126c80f35757f3c73e")
(setf (get your_package_name::FindWall :datatype-) "your_package_name/FindWall")
(setf (get your_package_name::FindWall :request) your_package_name::FindWallRequest)
(setf (get your_package_name::FindWall :response) your_package_name::FindWallResponse)

(defmethod your_package_name::FindWallRequest
  (:response () (instance your_package_name::FindWallResponse :init)))

(setf (get your_package_name::FindWallRequest :md5sum-) "66229cd821efb4126c80f35757f3c73e")
(setf (get your_package_name::FindWallRequest :datatype-) "your_package_name/FindWallRequest")
(setf (get your_package_name::FindWallRequest :definition-)
      "---
bool wallfound
")

(setf (get your_package_name::FindWallResponse :md5sum-) "66229cd821efb4126c80f35757f3c73e")
(setf (get your_package_name::FindWallResponse :datatype-) "your_package_name/FindWallResponse")
(setf (get your_package_name::FindWallResponse :definition-)
      "---
bool wallfound
")



(provide :your_package_name/FindWall "66229cd821efb4126c80f35757f3c73e")


