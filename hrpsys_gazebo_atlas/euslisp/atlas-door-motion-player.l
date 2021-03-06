#!/usr/bin/env roseus

(ros::load-ros-manifest "arm_navigation_msgs")
(ros::load-ros-manifest "jsk_interactive")
(ros::load-ros-manifest "jsk_interactive_marker")

(ros::roseus "atlas_door_motion_player")

(require "atlas-door.l")

(defvar *door-id* :first)
(defvar *door-setting*
  (case *door-id*
	(:first '(-650 -100 80))
	(:second '(750 400 -180))))

(apply #'init-door-setting
       (append *door-setting* (list nil)))
(send *atlas* :reset-manip-pose)
(make-foot-convex :force? t)
(defvar *atlas2* (copy-object *atlas*))

(defun update-from-real
  nil
  (send *atlas* :angle-vector
	(copy-object (send *atlas2* :angle-vector)))
  (send *atlas* :fix-leg-to-coords
	(make-coords
	 :pos (float-vector
	       (car *door-setting*)
	       (cadr *door-setting*) 0)
	 :rpy (list (deg2rad (caddr *door-setting*)) 0 0))))

(defun joint-state-subscriber
  (msg)
  (format t "[joint-state-subscriber] called ")
  (bench
   (let ((joint-names (send msg :name))
	 (joint-angles (send msg :position))
	 joint-name joint-angle
	 buf
	 )
     ;;(describe msg)
     (dotimes (x (length joint-names))
       (setq joint-name (elt joint-names x))
       ;;(print joint-name)
       (setq joint-angle (rad2deg (elt joint-angles x)))
       (setq buf
	     (intern (string-upcase joint-name) *keyword-package*))
       (if (find-method *atlas2* buf)
	   (send *atlas2* buf :joint-angle joint-angle))
       )
     )))

(defun marker-menu-callback
  (msg)
  (let ((menu (send msg :menu))
	(type (send msg :type)))
    (cond
     ((eq menu jsk_interactive_marker::MarkerMenu::*RESET_JOINT*)
      (format t "[marker-menu-callback] call update-from-real~%")
      (update-from-real)
      ))))

(defvar *im-nodename* "jsk_model_marker_interface")
(ros::subscribe
 (format nil "~A/marker_menu" *im-nodename*)
 jsk_interactive_marker::MarkerMenu
 #'marker-menu-callback 1)

(ros::subscribe
 "/atlas/joint_states_decompressed"
 sensor_msgs::JointState
 #'joint-state-subscriber 1)

(case *door-id*
      (:first
       (setq
	*angle-vector-list*
	(list
	 ;; initial pose
	 '(lambda (&rest args)
	    (send *atlas* :stand-pose)
	    (send *atlas* :angle-vector))
	 ;; walk pose
	 '(lambda (&rest args)
	    (send *atlas* :stand-pose)
	    (send *atlas* :head :neck-p :joint-angle 28)
	    (send *atlas* :larm :shoulder-r :joint-angle -70)
	    (send *atlas* :rarm :shoulder-r :joint-angle 70)
	    (send *atlas* :angle-vector))
	 ;; lift rarm 1
	 '(lambda (&rest args)
	    (send *atlas* :stand-pose)
	    (send *atlas* :head :neck-p :joint-angle 28)
	    (send *atlas* :larm :shoulder-r :joint-angle -70)
	    (send *atlas* :rarm :shoulder-r :joint-angle 70)
	    (send *atlas* :rarm :angle-vector #f(-49.1897 124.848 -17.3907 64.6379 38.3492 5.17648))
	    (send *atlas* :angle-vector))
	 ;; lift rarm 2
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-62.5938 131.244 -32.5586 43.9041 38.6746 18.6351))
	   (send *atlas* :angle-vector))
	 ;; lift rarm 3
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-80.2396 130.481 -54.3879 9.58213 28.6782 30.6859))
	   (send *atlas* :angle-vector))
	 ;; lift rarm 4
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-94.5212 128.917 -65.3394 -17.2543 12.862 39.808))
	   (send *atlas* :angle-vector))
	 ;; touch it
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-81.2747 122.091 -36.7519 -3.61823 -2.2881 46.4515))
	   (send *atlas* :angle-vector))
	 ;; pull a little bit
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-97.7967 112.154 -33.1243 0.295946 23.7884 43.0624))
	   (send *atlas* :angle-vector))
	 ;; move rarm in the left direction 1
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-120.813 108.05 -18.3405 43.1798 21.4795 45.6492))
	   (send *atlas* :angle-vector))
	 ;; move rarm in the left direction 2
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-112.218 116.057 -9.89808 58.323 4.55004 51.4077))
	   (send *atlas* :angle-vector))
	 ;; touch it
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-98.0873 104.018 1.14069 58.463 -10.9421 54.1512))
	   (send *atlas* :angle-vector))
	 ;; pull a little bit
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-100.029 107.337 5.63386 77.3562 -3.07029 57.9547))
	   (send *atlas* :angle-vector))
	 ;; touch it downward 1
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-93.1819 116.099 0.315452 55.1884 -4.43202 62.5001))
	   (send *atlas* :angle-vector))
	 ;; touch it downward 2
	 '(lambda (&rest args)
	   (send *atlas* :stand-pose)
	   (send *atlas* :head :neck-p :joint-angle 28)
	   (send *atlas* :larm :shoulder-r :joint-angle -70)
	   (send *atlas* :rarm :shoulder-r :joint-angle 70)
	   (send *atlas* :rarm :angle-vector #f(-79.3501 120.45 0.185244 53.9922 -12.5073 64.6422))
	   (send *atlas* :angle-vector))
	 )))
      ;; (:first
      ;;  (setq
      ;; 	*angle-vector-list*
      ;; 	(list
      ;; 	 #f(0.0 3.0 0.0 120.0 100.0 5.0 -65.0 35.0 90.0 -126.851 167.544 66.7547 37.286 27.6476 111.557 28.0 -1.7 -12.5 1.7 -15.5 0.0 28.0 1.7 -12.5 -1.7 -15.5 0.0 0.0)
      ;; 	 #f(0.0 3.0 0.0 120.0 100.0 5.0 -65.0 35.0 90.0 -135.0 162.593 67.5002 24.9209 27.1113 104.142 28.0 -1.7 -12.5 1.7 -15.5 0.0 28.0 1.7 -12.5 -1.7 -15.5 0.0 0.0)
      ;; 	 #f(0.0 3.0 0.0 120.0 100.0 5.0 -65.0 35.0 90.0 -135.0 157.148 67.5002 20.5246 26.5905 97.5366 28.0 -1.7 -12.5 1.7 -15.5 0.0 28.0 1.7 -12.5 -1.7 -15.5 0.0 0.0)
      ;; 	 #f(0.0 3.0 0.0 120.0 100.0 5.0 -65.0 35.0 90.0 -130.656 111.167 20.8357 36.3135 45.0 83.7744 28.0 -1.7 -12.5 1.7 -15.5 0.0 28.0 1.7 -12.5 -1.7 -15.5 0.0 0.0)
      ;; 	 '(lambda (&rest args)
      ;; 	    (send *atlas* :rarm :move-end-pos #f(-25 0 0) :world :revert-if-fail nil)
      ;; 	    (send *atlas* :angle-vector))
      ;; 	 '(lambda (&rest args)
      ;; 	    (send *atlas* :rarm :move-end-pos #f(0 0 -100) :world :revert-if-fail nil)
      ;; 	    (send *atlas* :angle-vector))
      ;; 	 '(lambda (&rest args)
      ;; 	    (send *atlas* :rarm :move-end-pos #f(0 0 -100) :world :revert-if-fail nil)
      ;; 	    (send *atlas* :angle-vector))
      ;; 	 '(lambda (&rest args)
      ;; 	    (send *atlas* :rarm :move-end-pos #f(200 0 0) :world :revert-if-fail nil)
      ;; 	    (send *atlas* :angle-vector))
      ;; 	 '(lambda (&rest args)
      ;; 	    (send *atlas* :rarm :move-end-pos #f(100 -30 0) :world :revert-if-fail nil)
      ;; 	    (send *atlas* :angle-vector))
      ;; 	 '(lambda (&rest args)
      ;; 	    (send *atlas* :rarm :elbow-y :joint-angle 40)
      ;; 	    (send *atlas* :angle-vector))
      ;; 	 )))
      ;;
      ;;
      (:second
       (setq
	*angle-vector-list*
	(list
	 #f(0.0 3.0 0.0 133.387 125.213 4.24709 -66.1523 32.52 90.2245 -120.0 100.0 -5.0 65.0 35.0 90.0 28.0 -1.7 -12.5 1.7 -15.5 0.0 28.0 1.7 -12.5 -1.7 -15.5 0.0 0.0)
	 #f(0.0 3.0 0.0 118.437 115.185 -1.65525 -81.5932 15.9529 91.772 -120.0 100.0 -5.0 65.0 35.0 90.0 28.0 -1.7 -12.5 1.7 -15.5 0.0 28.0 1.7 -12.5 -1.7 -15.5 0.0 0.0)
	 #f(0.0 3.0 0.0 107.79 99.3277 -9.86138 -81.0096 -8.76787 94.8195 -120.0 100.0 -5.0 65.0 35.0 90.0 28.0 -1.7 -12.5 1.7 -15.5 0.0 28.0 1.7 -12.5 -1.7 -15.5 0.0 0.0)
	 '(lambda (&rest args)
	    (send *atlas* :larm :move-end-pos #f(15 0 0) :world :revert-if-fail nil)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :larm :move-end-pos #f(0 0 -100) :world :rotation-axis nil :revert-if-fail nil)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :larm :move-end-pos #f(0 0 -150) :world :rotation-axis nil :revert-if-fail nil)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :larm :move-end-pos #f(100 0 0) :world :rotation-axis nil :revert-if-fail nil)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :larm :move-end-pos #f(100 -20 0) :world :rotation-axis nil :revert-if-fail nil)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :larm :move-end-pos #f(100 -20 0) :world :rotation-axis nil :revert-if-fail nil)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :rarm :angle-vector #f(-117.745 83.6972 -67.5002 64.5406 21.0539 74.7479))
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :rarm :angle-vector #f(-106.029 113.208 -23.7951 33.3744 -28.2753 52.5088))
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :rarm :angle-vector #f(-99.7026 114.146 -34.9985 42.5944 -42.1653 55.4058))
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :larm :move-end-pos #f(0 0 100) :world :rotation-axis nil :revert-if-fail nil)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :larm :move-end-pos #f(100 -100 0) :world :rotation-axis t :revert-if-fail nil)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :larm :angle-vector #f(28.5 114.5 0.0 -75.0 17.0 0.0))
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :rarm :move-end-pos #f(50 -100 0) :world :rotation-axis nil :revert-if-fail nil)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :torso :waist-y :joint-angle 15)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :torso :waist-y :joint-angle 30)
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :rarm :angle-vector #f(-120.0 100.0 -5.0 65.0 35.0 90.0))
	    (send *atlas* :angle-vector))
	 '(lambda (&rest args)
	    (send *atlas* :stand-pose)
	    (send *atlas* :angle-vector))))
       ))

(require "angle-vector-player.l")
