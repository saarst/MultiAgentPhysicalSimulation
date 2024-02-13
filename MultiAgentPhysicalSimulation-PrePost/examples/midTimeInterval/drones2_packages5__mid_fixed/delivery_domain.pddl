(define (domain delivery)
	(:requirements :typing :durative-actions :fluents :duration-inequalities)
	(:predicates
		(first-time)
		(TL0start)
		(TL1start)
		(TL0)
		(TL1)
	
		(drone1-delivery-ongoing)
		(drone1-complete-delivery)
		(drone1-busy)
		(drone1-slot1-full)
		(drone1-has-package1-at-slot1)
		(drone1-has-package2-at-slot1)
		(drone1-has-package3-at-slot1)
		(drone1-has-package4-at-slot1)
		(drone1-has-package5-at-slot1)

		(drone2-delivery-ongoing)
		(drone2-complete-delivery)
		(drone2-busy)
		(drone2-slot1-full)
		(drone2-has-package1-at-slot1)
		(drone2-has-package2-at-slot1)
		(drone2-has-package3-at-slot1)
		(drone2-has-package4-at-slot1)
		(drone2-has-package5-at-slot1)

		(package1-at-warehouse1)
		(package2-at-warehouse1)
		(package3-at-warehouse1)
		(package4-at-warehouse1)
		(package5-at-warehouse1)
		(package1-at-warehouse2)
		(package2-at-warehouse2)
		(package3-at-warehouse2)
		(package4-at-warehouse2)
		(package5-at-warehouse2)
		(house1-needs-package1)
		(house1-got-package1)
		(house1-needs-package2)
		(house1-got-package2)
		(house1-needs-package3)
		(house1-got-package3)
		(house1-needs-package4)
		(house1-got-package4)
		(house1-needs-package5)
		(house1-got-package5)
		(house2-needs-package1)
		(house2-got-package1)
		(house2-needs-package2)
		(house2-got-package2)
		(house2-needs-package3)
		(house2-got-package3)
		(house2-needs-package4)
		(house2-got-package4)
		(house2-needs-package5)
		(house2-got-package5)
		(house3-needs-package1)
		(house3-got-package1)
		(house3-needs-package2)
		(house3-got-package2)
		(house3-needs-package3)
		(house3-got-package3)
		(house3-needs-package4)
		(house3-got-package4)
		(house3-needs-package5)
		(house3-got-package5)
		(house4-needs-package1)
		(house4-got-package1)
		(house4-needs-package2)
		(house4-got-package2)
		(house4-needs-package3)
		(house4-got-package3)
		(house4-needs-package4)
		(house4-got-package4)
		(house4-needs-package5)
		(house4-got-package5)
	)

	(:functions
		(drone1-x)
		(drone1-y)
		(drone1-battery)
		(drone2-x)
		(drone2-y)
		(drone2-battery)
	)

	
    (:control-variable vx-drone1
		:bounds (and (>= ?value -15.0) (<= ?value 15.0))
	)

	(:control-variable vy-drone1
		:bounds (and (>= ?value -15.0) (<= ?value 15.0))
	)

	(:control-variable-vector energy-drone1
		:control-variables ((vx-drone1) (vy-drone1))
		:max-norm 15
	)
	
    (:control-variable vx-drone2
		:bounds (and (>= ?value -15.0) (<= ?value 15.0))
	)

	(:control-variable vy-drone2
		:bounds (and (>= ?value -15.0) (<= ?value 15.0))
	)

	(:control-variable-vector energy-drone2
		:control-variables ((vx-drone2) (vy-drone2))
		:max-norm 15
	)


	(:region earth
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (0 0) :width 1280 :height 1280))
	)

	(:region house1-region
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (92 782) :width 32 :height 32))
	)

	(:region house2-region
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (732 82) :width 32 :height 32))
	)

	(:region house3-region
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (332 382) :width 32 :height 32))
	)

	(:region house4-region
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (1132 1002) :width 32 :height 32))
	)

	(:region warehouse1-region
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (466 1122) :width 32 :height 32))
	)

	(:region warehouse2-region
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (982 482) :width 32 :height 32))
	)

	(:region helipad-region
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (640 640) :width 32 :height 32))
	)

	; start the delivery, this action starts the plan
	(:durative-action start-delivery
		:duration (and (>= ?duration 0.1) (<= ?duration 0.1))
		:condition (and
			(at start (first-time))
            (at end (drone1-busy))
            (at end (drone2-busy))
            (at end (not (TL0start)))		
			(at end (not (TL1start)))
		)
		:effect (and
			(at start (not (first-time)))
            (at start (TL0start))
			(at start (TL1start))
		)
	)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;	drone1 delivery actions
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:durative-action drone1-deliver-house1-package1-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package1-at-slot1))
			(at start (house1-needs-package1))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package1-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house1-needs-package1)))
            (at end (house1-got-package1))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house1-package2-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package2-at-slot1))
			(at start (house1-needs-package2))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package2-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house1-needs-package2)))
            (at end (house1-got-package2))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house1-package3-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package3-at-slot1))
			(at start (house1-needs-package3))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package3-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house1-needs-package3)))
            (at end (house1-got-package3))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house1-package4-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package4-at-slot1))
			(at start (house1-needs-package4))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package4-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house1-needs-package4)))
            (at end (house1-got-package4))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house1-package5-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package5-at-slot1))
			(at start (house1-needs-package5))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package5-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house1-needs-package5)))
            (at end (house1-got-package5))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house2-package1-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package1-at-slot1))
			(at start (house2-needs-package1))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package1-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house2-needs-package1)))
            (at end (house2-got-package1))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house2-package2-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package2-at-slot1))
			(at start (house2-needs-package2))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package2-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house2-needs-package2)))
            (at end (house2-got-package2))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house2-package3-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package3-at-slot1))
			(at start (house2-needs-package3))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package3-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house2-needs-package3)))
            (at end (house2-got-package3))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house2-package4-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package4-at-slot1))
			(at start (house2-needs-package4))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package4-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house2-needs-package4)))
            (at end (house2-got-package4))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house2-package5-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package5-at-slot1))
			(at start (house2-needs-package5))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package5-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house2-needs-package5)))
            (at end (house2-got-package5))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house3-package1-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package1-at-slot1))
			(at start (house3-needs-package1))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package1-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house3-needs-package1)))
            (at end (house3-got-package1))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house3-package2-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package2-at-slot1))
			(at start (house3-needs-package2))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package2-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house3-needs-package2)))
            (at end (house3-got-package2))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house3-package3-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package3-at-slot1))
			(at start (house3-needs-package3))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package3-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house3-needs-package3)))
            (at end (house3-got-package3))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house3-package4-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package4-at-slot1))
			(at start (house3-needs-package4))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package4-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house3-needs-package4)))
            (at end (house3-got-package4))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house3-package5-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package5-at-slot1))
			(at start (house3-needs-package5))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package5-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house3-needs-package5)))
            (at end (house3-got-package5))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house4-package1-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package1-at-slot1))
			(at start (house4-needs-package1))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package1-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house4-needs-package1)))
            (at end (house4-got-package1))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house4-package2-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package2-at-slot1))
			(at start (house4-needs-package2))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package2-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house4-needs-package2)))
            (at end (house4-got-package2))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house4-package3-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package3-at-slot1))
			(at start (house4-needs-package3))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package3-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house4-needs-package3)))
            (at end (house4-got-package3))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house4-package4-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package4-at-slot1))
			(at start (house4-needs-package4))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package4-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house4-needs-package4)))
            (at end (house4-got-package4))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	(:durative-action drone1-deliver-house4-package5-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package5-at-slot1))
			(at start (house4-needs-package5))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package5-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house4-needs-package5)))
            (at end (house4-got-package5))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;	drone2 delivery actions
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:durative-action drone2-deliver-house1-package1-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package1-at-slot1))
			(at start (house1-needs-package1))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package1-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house1-needs-package1)))
            (at end (house1-got-package1))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house1-package2-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package2-at-slot1))
			(at start (house1-needs-package2))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package2-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house1-needs-package2)))
            (at end (house1-got-package2))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house1-package3-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package3-at-slot1))
			(at start (house1-needs-package3))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package3-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house1-needs-package3)))
            (at end (house1-got-package3))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house1-package4-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package4-at-slot1))
			(at start (house1-needs-package4))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package4-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house1-needs-package4)))
            (at end (house1-got-package4))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house1-package5-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house1-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package5-at-slot1))
			(at start (house1-needs-package5))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package5-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house1-needs-package5)))
            (at end (house1-got-package5))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house2-package1-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package1-at-slot1))
			(at start (house2-needs-package1))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package1-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house2-needs-package1)))
            (at end (house2-got-package1))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house2-package2-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package2-at-slot1))
			(at start (house2-needs-package2))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package2-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house2-needs-package2)))
            (at end (house2-got-package2))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house2-package3-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package3-at-slot1))
			(at start (house2-needs-package3))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package3-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house2-needs-package3)))
            (at end (house2-got-package3))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house2-package4-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package4-at-slot1))
			(at start (house2-needs-package4))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package4-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house2-needs-package4)))
            (at end (house2-got-package4))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house2-package5-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house2-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package5-at-slot1))
			(at start (house2-needs-package5))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package5-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house2-needs-package5)))
            (at end (house2-got-package5))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house3-package1-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package1-at-slot1))
			(at start (house3-needs-package1))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package1-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house3-needs-package1)))
            (at end (house3-got-package1))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house3-package2-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package2-at-slot1))
			(at start (house3-needs-package2))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package2-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house3-needs-package2)))
            (at end (house3-got-package2))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house3-package3-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package3-at-slot1))
			(at start (house3-needs-package3))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package3-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house3-needs-package3)))
            (at end (house3-got-package3))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house3-package4-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package4-at-slot1))
			(at start (house3-needs-package4))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package4-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house3-needs-package4)))
            (at end (house3-got-package4))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house3-package5-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            (at end (TL0))
            (at end (not (TL1)))
			(at end   (inside (house3-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package5-at-slot1))
			(at start (house3-needs-package5))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package5-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house3-needs-package5)))
            (at end (house3-got-package5))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house4-package1-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package1-at-slot1))
			(at start (house4-needs-package1))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package1-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house4-needs-package1)))
            (at end (house4-got-package1))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house4-package2-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package2-at-slot1))
			(at start (house4-needs-package2))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package2-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house4-needs-package2)))
            (at end (house4-got-package2))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house4-package3-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package3-at-slot1))
			(at start (house4-needs-package3))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package3-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house4-needs-package3)))
            (at end (house4-got-package3))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house4-package4-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package4-at-slot1))
			(at start (house4-needs-package4))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package4-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house4-needs-package4)))
            (at end (house4-got-package4))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action drone2-deliver-house4-package5-at-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
            ; 
            ;;
			(at end   (inside (house4-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package5-at-slot1))
			(at start (house4-needs-package5))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package5-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house4-needs-package5)))
            (at end (house4-got-package5))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;	drone1 pickup actions
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(:durative-action drone1-pickup-package1-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at start  (package1-at-warehouse1))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package1-at-slot1))
			(at end    (not(package1-at-warehouse1)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
	(:durative-action drone1-pickup-package2-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at start  (package2-at-warehouse1))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package2-at-slot1))
			(at end    (not(package2-at-warehouse1)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
	(:durative-action drone1-pickup-package3-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at start  (package3-at-warehouse1))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package3-at-slot1))
			(at end    (not(package3-at-warehouse1)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
	(:durative-action drone1-pickup-package4-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at start  (package4-at-warehouse1))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package4-at-slot1))
			(at end    (not(package4-at-warehouse1)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
	(:durative-action drone1-pickup-package5-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at start  (package5-at-warehouse1))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package5-at-slot1))
			(at end    (not(package5-at-warehouse1)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
	(:durative-action drone1-pickup-package1-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at start  (package1-at-warehouse2))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package1-at-slot1))
			(at end    (not(package1-at-warehouse2)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
	(:durative-action drone1-pickup-package2-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at start  (package2-at-warehouse2))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package2-at-slot1))
			(at end    (not(package2-at-warehouse2)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
	(:durative-action drone1-pickup-package3-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at start  (package3-at-warehouse2))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package3-at-slot1))
			(at end    (not(package3-at-warehouse2)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
	(:durative-action drone1-pickup-package4-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at start  (package4-at-warehouse2))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package4-at-slot1))
			(at end    (not(package4-at-warehouse2)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
	(:durative-action drone1-pickup-package5-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone1-delivery-ongoing))
			(at end  (drone1-delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at end    (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at start  (package5-at-warehouse2))
			(at start  (not (drone1-slot1-full)))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at end    (drone1-has-package5-at-slot1))
			(at end    (not(package5-at-warehouse2)))
			(at end    (drone1-slot1-full))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;	drone2 pickup actions
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(:durative-action drone2-pickup-package1-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at start  (package1-at-warehouse1))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package1-at-slot1))
			(at end    (not(package1-at-warehouse1)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	(:durative-action drone2-pickup-package2-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at start  (package2-at-warehouse1))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package2-at-slot1))
			(at end    (not(package2-at-warehouse1)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	(:durative-action drone2-pickup-package3-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at start  (package3-at-warehouse1))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package3-at-slot1))
			(at end    (not(package3-at-warehouse1)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	(:durative-action drone2-pickup-package4-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at start  (package4-at-warehouse1))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package4-at-slot1))
			(at end    (not(package4-at-warehouse1)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	(:durative-action drone2-pickup-package5-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at start  (package5-at-warehouse1))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package5-at-slot1))
			(at end    (not(package5-at-warehouse1)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	(:durative-action drone2-pickup-package1-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at start  (package1-at-warehouse2))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package1-at-slot1))
			(at end    (not(package1-at-warehouse2)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	(:durative-action drone2-pickup-package2-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at start  (package2-at-warehouse2))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package2-at-slot1))
			(at end    (not(package2-at-warehouse2)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	(:durative-action drone2-pickup-package3-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at start  (package3-at-warehouse2))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package3-at-slot1))
			(at end    (not(package3-at-warehouse2)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	(:durative-action drone2-pickup-package4-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at start  (package4-at-warehouse2))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package4-at-slot1))
			(at end    (not(package4-at-warehouse2)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	(:durative-action drone2-pickup-package5-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at start  (drone2-delivery-ongoing))
			(at end  (drone2-delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at end    (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at start  (package5-at-warehouse2))
			(at start  (not (drone2-slot1-full)))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at end    (drone2-has-package5-at-slot1))
			(at end    (not(package5-at-warehouse2)))
			(at end    (drone2-slot1-full))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)


	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; ;	finish delivery
	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:durative-action drone1-finish-delivery
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at end (inside (helipad-region (drone1-x) (drone1-y))))
			(at start  (drone1-delivery-ongoing))
            (over all (>= (drone1-battery) 0))
		)
		:effect (and
			(at start (not (drone1-delivery-ongoing)))
			(at end (drone1-complete-delivery))
            (increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; ;	finish delivery
	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:durative-action drone2-finish-delivery
		:duration (and (>= ?duration 0.1) (<= ?duration 200))
		:condition (and
			(at end (inside (helipad-region (drone2-x) (drone2-y))))
			(at start  (drone2-delivery-ongoing))
            (over all (>= (drone2-battery) 0))
		)
		:effect (and
			(at start (not (drone2-delivery-ongoing)))
			(at end (drone2-complete-delivery))
            (increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)

	(:durative-action timedliteral0
		:duration (and (>= ?duration 180) (<= ?duration 180))
		:condition (and 
				(at start (TL0start))
				(at start (not (TL1start)))
		)

		:effect (and
			(at start (drone1-delivery-ongoing))
			(at start (drone2-delivery-ongoing))
			(at start (not (TL0start)))
			(at start (TL0)) 
			(at end (not (TL0)))
		)
	)
	
	(:durative-action timedliteral1
		:duration (and (>= ?duration 150) (<= ?duration 150))
		:condition (and 
				(at start (TL1start))
		)
		:effect (and 
			(at start (not (TL1start)))
			(at start (TL1)) 
			(at end (not (TL1)))
		)
	)


)
