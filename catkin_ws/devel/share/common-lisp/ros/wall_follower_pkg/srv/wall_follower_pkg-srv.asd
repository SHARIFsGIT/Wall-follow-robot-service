
(cl:in-package :asdf)

(defsystem "wall_follower_pkg-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "FindWall" :depends-on ("_package_FindWall"))
    (:file "_package_FindWall" :depends-on ("_package"))
  ))