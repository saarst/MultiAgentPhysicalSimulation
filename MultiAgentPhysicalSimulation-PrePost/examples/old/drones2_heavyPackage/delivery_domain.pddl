(define (domain delivery)
	(:requirements :typing :durative-actions :fluents :duration-inequalities)
	(:predicates
		(complete-delivery)
		(delivery-ongoing)
		(first-time)
	
		(drone1-fly)
		(drone1-busy)
		(drone1-slot1-full)
		(drone1-has-package1-at-slot1)
		(drone1-has-package2-at-slot1)
		(drone1-has-package3-at-slot1)
		(drone1-has-package4-at-slot1)

		(drone2-fly)
		(drone2-busy)
		(drone2-slot1-full)
		(drone2-has-package1-at-slot1)
		(drone2-has-package2-at-slot1)
		(drone2-has-package3-at-slot1)
		(drone2-has-package4-at-slot1)
		
		(drone12-fly)

		(warehouse1-busy)
		(package1-at-warehouse1)
		(package2-at-warehouse1)
		(package3-at-warehouse1)
		(package4-at-warehouse1)
		(warehouse2-busy)
		(package1-at-warehouse2)
		(package2-at-warehouse2)
		(package3-at-warehouse2)
		(package4-at-warehouse2)
		(house1-needs-package1)
		(house1-got-package1)
		(house1-needs-package2)
		(house1-got-package2)
		(house1-needs-package3)
		(house1-got-package3)
		(house1-needs-package4)
		(house1-got-package4)
		(house2-needs-package1)
		(house2-got-package1)
		(house2-needs-package2)
		(house2-got-package2)
		(house2-needs-package3)
		(house2-got-package3)
		(house2-needs-package4)
		(house2-got-package4)
		(house3-needs-package1)
		(house3-got-package1)
		(house3-needs-package2)
		(house3-got-package2)
		(house3-needs-package3)
		(house3-got-package3)
		(house3-needs-package4)
		(house3-got-package4)
		(house4-needs-package1)
		(house4-got-package1)
		(house4-needs-package2)
		(house4-got-package2)
		(house4-needs-package3)
		(house4-got-package3)
		(house4-needs-package4)
		(house4-got-package4)
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
		:bounds (and (>= ?value -20.0) (<= ?value 20.0))
	)

	(:control-variable vy-drone1
		:bounds (and (>= ?value -20.0) (<= ?value 20.0))
	)

	(:control-variable-vector energy-drone1
		:control-variables ((vx-drone1) (vy-drone1))
		:max-norm 800
	)
	
    (:control-variable vx-drone2
		:bounds (and (>= ?value -20.0) (<= ?value 20.0))
	)

	(:control-variable vy-drone2
		:bounds (and (>= ?value -20.0) (<= ?value 20.0))
	)

	(:control-variable-vector energy-drone2
		:control-variables ((vx-drone2) (vy-drone2))
		:max-norm 800
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
		:condition (and (in-rect (?x ?y) :corner (322 982) :width 32 :height 32))
	)

	(:region warehouse2-region
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (982 482) :width 32 :height 32))
	)

	(:region helipad-region
		:parameters (?x ?y)
		:condition (and (in-rect (?x ?y) :corner (640 640) :width 32 :height 32))
	)
	
	(:region recover-range
		:parameters (?x1 ?y1 ?x2 ?y2)
		:condition (and (max-distance ((?x1 ?y1) (?x2 ?y2)) :d 0.5)))

	; start the delivery, this action starts the plan
	(:durative-action start-delivery
		:duration (and (>= ?duration 0.1) (<= ?duration 0.1))
		:condition (and
			(at start (not (complete-delivery)))
			(at start (not (delivery-ongoing)))
			(at start (first-time))
            ;;;
            (at end  (drone1-fly))
            (at end  (drone2-fly))
            ;;;
		)
		:effect (and
			(at start (not (first-time)))
			(at start (delivery-ongoing))
		)
	)

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	drone1 fly actions
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	(:durative-action fly-drone1
		:duration (and (>= ?duration 0.1) (<= ?duration 200.0))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (inside (earth (drone1-x) (drone1-y))))
			(at end   (inside (earth (drone1-x) (drone1-y))))
			(at start  (not (drone1-fly)))
			(at end    (drone1-fly))
			(at start (not (drone12-fly)))
			(over all (>= (drone1-battery) 0))
		)
		:effect (and
            (at start  (drone1-fly))
			(at end    (not (drone1-fly)))
			(increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	drone2 fly actions
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	(:durative-action fly-drone2
		:duration (and (>= ?duration 0.1) (<= ?duration 200.0))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (inside (earth (drone2-x) (drone2-y))))
			(at end   (inside (earth (drone2-x) (drone2-y))))
			(at start  (not (drone2-fly)))
			(at end    (drone2-fly))
			(at start (not (drone12-fly)))
			(over all (>= (drone2-battery) 0))
		)
		:effect (and
            (at start  (drone2-fly))
			(at end    (not (drone2-fly)))
			(increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
		)
	)
	
		(:durative-action fly-drone12
		:duration (and (>= ?duration 0.1) (<= ?duration 200.0))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (inside (earth (drone2-x) (drone2-y))))
			(at end   (inside (earth (drone2-x) (drone2-y))))
			(at start (inside (earth (drone1-x) (drone1-y))))
			(at end   (inside (earth (drone1-x) (drone1-y))))
			(over all (inside (recover-range (drone1-x) (drone1-y) (drone2-x) (drone2-y))))
			(at start  (not (drone2-fly)))
			(at start  (not (drone1-fly)))
			(at start (drone12-fly))
			(over all (>= (drone2-battery) 0))
			(over all (>= (drone1-battery) 0))
			(at end    (not (drone12-fly)))
		)
		:effect (and
			(increase (drone2-x) (* (vx-drone2) #t))
			(increase (drone2-y) (* (vy-drone2) #t))
			(decrease (drone2-battery) (* 1.0 (norm (energy-drone2)) #t))
			(increase (drone1-x) (* (vx-drone1) #t))
			(increase (drone1-y) (* (vy-drone1) #t))
			(decrease (drone1-battery) (* 1.0 (norm (energy-drone1)) #t))
		)
	)

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;	drone1 delivery actions
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:durative-action drone1-deliver-house1-package1-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house1-region (drone1-x) (drone1-y) )))
			(at end   (inside (house1-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package1-at-slot1))
			(at start (house1-needs-package1))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package1-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house1-needs-package1)))
            (at end (house1-got-package1))
		)
	)

	(:durative-action drone1-deliver-house1-package2-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house1-region (drone1-x) (drone1-y) )))
			(at end   (inside (house1-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package2-at-slot1))
			(at start (house1-needs-package2))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package2-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house1-needs-package2)))
            (at end (house1-got-package2))
		)
	)



	(:durative-action drone1-deliver-house1-package4-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house1-region (drone1-x) (drone1-y) )))
			(at end   (inside (house1-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package4-at-slot1))
			(at start (house1-needs-package4))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package4-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house1-needs-package4)))
            (at end (house1-got-package4))
		)
	)

	(:durative-action drone1-deliver-house2-package1-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house2-region (drone1-x) (drone1-y) )))
			(at end   (inside (house2-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package1-at-slot1))
			(at start (house2-needs-package1))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package1-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house2-needs-package1)))
            (at end (house2-got-package1))
		)
	)

	(:durative-action drone1-deliver-house2-package2-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house2-region (drone1-x) (drone1-y) )))
			(at end   (inside (house2-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package2-at-slot1))
			(at start (house2-needs-package2))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package2-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house2-needs-package2)))
            (at end (house2-got-package2))
		)
	)



	(:durative-action drone1-deliver-house2-package4-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house2-region (drone1-x) (drone1-y) )))
			(at end   (inside (house2-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package4-at-slot1))
			(at start (house2-needs-package4))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package4-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house2-needs-package4)))
            (at end (house2-got-package4))
		)
	)

	(:durative-action drone1-deliver-house3-package1-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house3-region (drone1-x) (drone1-y) )))
			(at end   (inside (house3-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package1-at-slot1))
			(at start (house3-needs-package1))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package1-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house3-needs-package1)))
            (at end (house3-got-package1))
		)
	)

	(:durative-action drone1-deliver-house3-package2-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house3-region (drone1-x) (drone1-y) )))
			(at end   (inside (house3-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package2-at-slot1))
			(at start (house3-needs-package2))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package2-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house3-needs-package2)))
            (at end (house3-got-package2))
		)
	)

	(:durative-action drone12-deliver-house3-package3-at-slot11
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house3-region (drone1-x) (drone1-y) )))
			(at end   (inside (house3-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package3-at-slot1))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house3-region (drone2-x) (drone2-y) )))
			(at end   (inside (house3-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package3-at-slot1))
			(at start (house3-needs-package3))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package3-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package3-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house3-needs-package3)))
            (at end (house3-got-package3))
			(at end (not (drone12-fly)))
		)
	)

	(:durative-action drone1-deliver-house3-package4-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house3-region (drone1-x) (drone1-y) )))
			(at end   (inside (house3-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package4-at-slot1))
			(at start (house3-needs-package4))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package4-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house3-needs-package4)))
            (at end (house3-got-package4))
		)
	)

	(:durative-action drone1-deliver-house4-package1-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house4-region (drone1-x) (drone1-y) )))
			(at end   (inside (house4-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package1-at-slot1))
			(at start (house4-needs-package1))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package1-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house4-needs-package1)))
            (at end (house4-got-package1))
		)
	)

	(:durative-action drone1-deliver-house4-package2-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house4-region (drone1-x) (drone1-y) )))
			(at end   (inside (house4-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package2-at-slot1))
			(at start (house4-needs-package2))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package2-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house4-needs-package2)))
            (at end (house4-got-package2))
		)
	)



	(:durative-action drone1-deliver-house4-package4-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone1-busy)))
			(at end   (drone1-busy))
			(at start (inside (house4-region (drone1-x) (drone1-y) )))
			(at end   (inside (house4-region (drone1-x) (drone1-y) )))
			(at start (drone1-has-package4-at-slot1))
			(at start (house4-needs-package4))
		)
		:effect (and
			(at start (drone1-busy))
			(at end (not (drone1-busy)))
			(at end (not (drone1-has-package4-at-slot1)))
			(at end (not (drone1-slot1-full)))
			(at end (not (house4-needs-package4)))
            (at end (house4-got-package4))
		)
	)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;	drone2 delivery actions
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:durative-action drone2-deliver-house1-package1-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house1-region (drone2-x) (drone2-y) )))
			(at end   (inside (house1-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package1-at-slot1))
			(at start (house1-needs-package1))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package1-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house1-needs-package1)))
            (at end (house1-got-package1))
		)
	)

	(:durative-action drone2-deliver-house1-package2-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house1-region (drone2-x) (drone2-y) )))
			(at end   (inside (house1-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package2-at-slot1))
			(at start (house1-needs-package2))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package2-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house1-needs-package2)))
            (at end (house1-got-package2))
		)
	)



	(:durative-action drone2-deliver-house1-package4-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house1-region (drone2-x) (drone2-y) )))
			(at end   (inside (house1-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package4-at-slot1))
			(at start (house1-needs-package4))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package4-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house1-needs-package4)))
            (at end (house1-got-package4))
		)
	)

	(:durative-action drone2-deliver-house2-package1-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house2-region (drone2-x) (drone2-y) )))
			(at end   (inside (house2-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package1-at-slot1))
			(at start (house2-needs-package1))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package1-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house2-needs-package1)))
            (at end (house2-got-package1))
		)
	)

	(:durative-action drone2-deliver-house2-package2-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house2-region (drone2-x) (drone2-y) )))
			(at end   (inside (house2-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package2-at-slot1))
			(at start (house2-needs-package2))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package2-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house2-needs-package2)))
            (at end (house2-got-package2))
		)
	)



	(:durative-action drone2-deliver-house2-package4-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house2-region (drone2-x) (drone2-y) )))
			(at end   (inside (house2-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package4-at-slot1))
			(at start (house2-needs-package4))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package4-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house2-needs-package4)))
            (at end (house2-got-package4))
		)
	)

	(:durative-action drone2-deliver-house3-package1-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house3-region (drone2-x) (drone2-y) )))
			(at end   (inside (house3-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package1-at-slot1))
			(at start (house3-needs-package1))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package1-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house3-needs-package1)))
            (at end (house3-got-package1))
		)
	)

	(:durative-action drone2-deliver-house3-package2-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house3-region (drone2-x) (drone2-y) )))
			(at end   (inside (house3-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package2-at-slot1))
			(at start (house3-needs-package2))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package2-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house3-needs-package2)))
            (at end (house3-got-package2))
		)
	)


	(:durative-action drone2-deliver-house3-package4-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house3-region (drone2-x) (drone2-y) )))
			(at end   (inside (house3-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package4-at-slot1))
			(at start (house3-needs-package4))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package4-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house3-needs-package4)))
            (at end (house3-got-package4))
		)
	)

	(:durative-action drone2-deliver-house4-package1-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house4-region (drone2-x) (drone2-y) )))
			(at end   (inside (house4-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package1-at-slot1))
			(at start (house4-needs-package1))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package1-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house4-needs-package1)))
            (at end (house4-got-package1))
		)
	)

	(:durative-action drone2-deliver-house4-package2-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house4-region (drone2-x) (drone2-y) )))
			(at end   (inside (house4-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package2-at-slot1))
			(at start (house4-needs-package2))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package2-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house4-needs-package2)))
            (at end (house4-got-package2))
		)
	)


	(:durative-action drone2-deliver-house4-package4-at-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start (not (drone2-busy)))
			(at end   (drone2-busy))
			(at start (inside (house4-region (drone2-x) (drone2-y) )))
			(at end   (inside (house4-region (drone2-x) (drone2-y) )))
			(at start (drone2-has-package4-at-slot1))
			(at start (house4-needs-package4))
		)
		:effect (and
			(at start (drone2-busy))
			(at end (not (drone2-busy)))
			(at end (not (drone2-has-package4-at-slot1)))
			(at end (not (drone2-slot1-full)))
			(at end (not (house4-needs-package4)))
            (at end (house4-got-package4))
		)
	)

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;	drone1 pickup actions
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(:durative-action drone1-pickup-package1-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at start  (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at end    (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at start  (not (warehouse1-busy)))
			(at start  (package1-at-warehouse1))
			(at start  (not (drone1-slot1-full)))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at start  (warehouse1-busy))
			(at end    (not(warehouse1-busy)))
			(at end    (drone1-has-package1-at-slot1))
			(at end    (not(package1-at-warehouse1)))
			(at end    (drone1-slot1-full))
		)
	)
	(:durative-action drone1-pickup-package2-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at start  (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at end    (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at start  (not (warehouse1-busy)))
			(at start  (package2-at-warehouse1))
			(at start  (not (drone1-slot1-full)))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at start  (warehouse1-busy))
			(at end    (not(warehouse1-busy)))
			(at end    (drone1-has-package2-at-slot1))
			(at end    (not(package2-at-warehouse1)))
			(at end    (drone1-slot1-full))
		)
	)

	
	(:durative-action drone1-pickup-package4-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at start  (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at end    (inside (warehouse1-region (drone1-x) (drone1-y) )))
			(at start  (not (warehouse1-busy)))
			(at start  (package4-at-warehouse1))
			(at start  (not (drone1-slot1-full)))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at start  (warehouse1-busy))
			(at end    (not(warehouse1-busy)))
			(at end    (drone1-has-package4-at-slot1))
			(at end    (not(package4-at-warehouse1)))
			(at end    (drone1-slot1-full))
		)
	)
	(:durative-action drone1-pickup-package1-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at start  (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at end    (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at start  (not (warehouse2-busy)))
			(at start  (package1-at-warehouse2))
			(at start  (not (drone1-slot1-full)))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at start  (warehouse2-busy))
			(at end    (not(warehouse2-busy)))
			(at end    (drone1-has-package1-at-slot1))
			(at end    (not(package1-at-warehouse2)))
			(at end    (drone1-slot1-full))
		)
	)
	(:durative-action drone1-pickup-package2-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at start  (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at end    (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at start  (not (warehouse2-busy)))
			(at start  (package2-at-warehouse2))
			(at start  (not (drone1-slot1-full)))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at start  (warehouse2-busy))
			(at end    (not(warehouse2-busy)))
			(at end    (drone1-has-package2-at-slot1))
			(at end    (not(package2-at-warehouse2)))
			(at end    (drone1-slot1-full))
		)
	)
	(:durative-action drone12-pickup-package3-from-warehouse2-into-slot11
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at start (not (drone1-fly)))
			(at start (not (drone2-fly)))
			(at start  (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at end    (inside (warehouse2-region (drone1-x) (drone1-y) )))
			
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at start  (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at end    (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at start  (not (warehouse2-busy)))
			(at start  (package3-at-warehouse2))
			(at start  (not (drone1-slot1-full)))
			(at start  (not (drone2-slot1-full)))

		)
		:effect (and
			(at start (drone12-fly))
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))			
			(at start  (warehouse2-busy))
			(at end    (not(warehouse2-busy)))
			(at end    (drone1-has-package3-at-slot1))
			(at end    (drone2-has-package3-at-slot1))

			(at end    (not(package3-at-warehouse2)))
			(at end    (drone1-slot1-full))
			(at end    (drone2-slot1-full))

		)
	)
	(:durative-action drone1-pickup-package4-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone1-busy)))
			(at end    (drone1-busy))
			(at start  (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at end    (inside (warehouse2-region (drone1-x) (drone1-y) )))
			(at start  (not (warehouse2-busy)))
			(at start  (package4-at-warehouse2))
			(at start  (not (drone1-slot1-full)))
		)
		:effect (and
			(at start  (drone1-busy))
			(at end    (not (drone1-busy)))
			(at start  (warehouse2-busy))
			(at end    (not(warehouse2-busy)))
			(at end    (drone1-has-package4-at-slot1))
			(at end    (not(package4-at-warehouse2)))
			(at end    (drone1-slot1-full))
		)
	)
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;	drone2 pickup actions
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(:durative-action drone2-pickup-package1-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at start  (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at end    (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at start  (not (warehouse1-busy)))
			(at start  (package1-at-warehouse1))
			(at start  (not (drone2-slot1-full)))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at start  (warehouse1-busy))
			(at end    (not(warehouse1-busy)))
			(at end    (drone2-has-package1-at-slot1))
			(at end    (not(package1-at-warehouse1)))
			(at end    (drone2-slot1-full))
		)
	)
	(:durative-action drone2-pickup-package2-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at start  (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at end    (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at start  (not (warehouse1-busy)))
			(at start  (package2-at-warehouse1))
			(at start  (not (drone2-slot1-full)))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at start  (warehouse1-busy))
			(at end    (not(warehouse1-busy)))
			(at end    (drone2-has-package2-at-slot1))
			(at end    (not(package2-at-warehouse1)))
			(at end    (drone2-slot1-full))
		)
	)


	(:durative-action drone2-pickup-package4-from-warehouse1-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at start  (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at end    (inside (warehouse1-region (drone2-x) (drone2-y) )))
			(at start  (not (warehouse1-busy)))
			(at start  (package4-at-warehouse1))
			(at start  (not (drone2-slot1-full)))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at start  (warehouse1-busy))
			(at end    (not(warehouse1-busy)))
			(at end    (drone2-has-package4-at-slot1))
			(at end    (not(package4-at-warehouse1)))
			(at end    (drone2-slot1-full))
		)
	)
	(:durative-action drone2-pickup-package1-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at start  (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at end    (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at start  (not (warehouse2-busy)))
			(at start  (package1-at-warehouse2))
			(at start  (not (drone2-slot1-full)))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at start  (warehouse2-busy))
			(at end    (not(warehouse2-busy)))
			(at end    (drone2-has-package1-at-slot1))
			(at end    (not(package1-at-warehouse2)))
			(at end    (drone2-slot1-full))
		)
	)
	(:durative-action drone2-pickup-package2-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at start  (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at end    (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at start  (not (warehouse2-busy)))
			(at start  (package2-at-warehouse2))
			(at start  (not (drone2-slot1-full)))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at start  (warehouse2-busy))
			(at end    (not(warehouse2-busy)))
			(at end    (drone2-has-package2-at-slot1))
			(at end    (not(package2-at-warehouse2)))
			(at end    (drone2-slot1-full))
		)
	)


	(:durative-action drone2-pickup-package4-from-warehouse2-into-slot1
		:duration (and (>= ?duration 0.5) (<= ?duration 0.5))
		:condition (and
			(at start  (delivery-ongoing))
			(at end  (delivery-ongoing))
			(at start  (not (drone2-busy)))
			(at end    (drone2-busy))
			(at start  (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at end    (inside (warehouse2-region (drone2-x) (drone2-y) )))
			(at start  (not (warehouse2-busy)))
			(at start  (package4-at-warehouse2))
			(at start  (not (drone2-slot1-full)))
		)
		:effect (and
			(at start  (drone2-busy))
			(at end    (not (drone2-busy)))
			(at start  (warehouse2-busy))
			(at end    (not(warehouse2-busy)))
			(at end    (drone2-has-package4-at-slot1))
			(at end    (not(package4-at-warehouse2)))
			(at end    (drone2-slot1-full))
		)
	)


	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; ;	finish delivery
	; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	(:durative-action finish-delivery
		:duration (and (>= ?duration 0.1) (<= ?duration 0.1))
		:condition (and
			(at start (inside (helipad-region (drone1-x) (drone1-y))))
			(at start (inside (helipad-region (drone2-x) (drone2-y))))

			(at start  (delivery-ongoing))
		)
		:effect (and
			(at start (not (delivery-ongoing)))
			(at start (complete-delivery))
		)
	)

)
