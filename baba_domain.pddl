(define (domain baba)
    (:requirements :conditional-effects :disjunctive-preconditions :negative-preconditions :equality :adl :typing)

    (:types
        locateable location - object
        sprite text - locateable
        noun operator property - text
        baba rock wall flag - noun
        is - operator
        you push stop win - property
    )

    (:predicates
        (right_connected ?l1 ?l2 - location)
        (left_connected ?l1 ?l2 - location)
        (up_connected ?l1 ?l2 - location)
        (down_connected ?l1 ?l2 - location)

        (right_edge ?l1 - location)
        (left_edge ?l1 - location)
        (up_edge ?l1 - location)
        (down_edge ?l1 - location)

        (is_empty ?l1 - location)

        (is_at ?x - locateable ?l1 - location)
        (is_text ?x - text)
        
        (is_you ?x - locateable)
        (is_win ?x - locateable)
        (is_stop ?x - locateable)
        ;(is_background ?x - locateable) for when the object has no attributes (can be passed through but is still at a location)

        (is_rock ?x - locateable)
        (is_wall ?x - locateable)
        (is_flag ?x - locateable)
        (is_baba ?x - locateable)

        

        (is_pushable_right ?x - locateable)
        (is_pushable_left ?x - locateable)
        (is_pushable_up ?x - locateable)
        (is_pushable_down ?x - locateable)

        (moved_right ?x - locateable)
        (moved_left ?x - locateable)
        (moved_down ?x - locateable)
        (moved_up ?x - locateable)
    )

    ; Used to move the player (objects that have is_you)
    (:action move_right
        :parameters ()
        :precondition
        (or
            (exists ; if there is one player that has a pushable or background object to their right
                (?x ?y - locateable ?l1 ?l2 - location) 
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (is_at ?y ?l2)
                    (right_connected ?l1 ?l2)
                    (or
                        (is_pushable_right ?y)
                        (is_you ?y)
                    )
                )
            )
            (exists ; if there is one player that has nothing to their right
                (?x - locateable ?l1 ?l2 - location)
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (right_connected ?l1 ?l2)
                    (is_empty ?l2)
                )
            )
        )
        :effect 
        (forall (?x - locateable ?l1 ?l2 - location)
            (when 
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (right_connected ?l1 ?l2)
                    (or
                        (is_empty ?l2)
                        (exists (?y - locateable)
                            (and
                                (is_at ?y ?l2)
                                (or
                                    (is_pushable_right ?y)
                                    (is_you ?y)
                                )
                            )
                        )
                    )
                )
                (and
                    (is_at ?x ?l2)
                    (not (is_at ?x ?l1))
                    (moved_right ?x)
                )
            )
        )
    )

    (:action move_left
        :parameters ()
        :precondition 
        (or
            (exists ; if there is one player that has a pushable or background object to their right
                (?x ?y - locateable ?l1 ?l2 - location) 
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (is_at ?y ?l2)
                    (left_connected ?l1 ?l2)
                    (or
                        (is_pushable_left ?y)
                        (is_you ?y)
                    )
                )
            )
            (exists ; if there is one player that has nothing to their right
                (?x - locateable ?l1 ?l2 - location)
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (left_connected ?l1 ?l2)
                    (is_empty ?l2)
                )
            )
        )
        :effect 
        (forall (?x - locateable ?l1 ?l2 - location)
            (when 
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (left_connected ?l1 ?l2)
                    (or
                        (is_empty ?l2)
                        (exists (?y - locateable)
                            (and
                                (is_at ?y ?l2)
                                (or
                                    (is_pushable_left ?y)
                                    (is_you ?y)
                                )
                            )
                        )
                    )
                )
                (and
                    (is_at ?x ?l2)
                    (not (is_at ?x ?l1))
                    (moved_left ?x)
                )
            )
        )
    )

    (:action move_up
        :parameters ()
        :precondition
        (or
            (exists ; if there is one player that has a pushable or background object to their right
                (?x ?y - locateable ?l1 ?l2 - location) 
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (is_at ?y ?l2)
                    (up_connected ?l1 ?l2)
                    (or
                        (is_pushable_up ?y)
                        (is_you ?y)
                    )
                )
            )
            (exists ; if there is one player that has nothing to their right
                (?x - locateable ?l1 ?l2 - location)
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (up_connected ?l1 ?l2)
                    (is_empty ?l2)
                )
            )
        )        
        :effect
        (forall (?x - locateable ?l1 ?l2 - location)
            (when 
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (up_connected ?l1 ?l2)
                    (or
                        (is_empty ?l2)
                        (exists (?y - locateable)
                            (and
                                (is_at ?y ?l2)
                                (or
                                    (is_pushable_up ?y)
                                    (is_you ?y)
                                )
                            )
                        )
                    )
                )
                (and
                    (is_at ?x ?l2)
                    (not (is_at ?x ?l1))
                    (moved_up ?x)
                )
            )
        )
    )

    (:action move_down
        :parameters ()
        :precondition
        (or
            (exists ; if there is one player that has a pushable or background object to their right
                (?x ?y - locateable ?l1 ?l2 - location) 
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (is_at ?y ?l2)
                    (down_connected ?l1 ?l2)
                    (or
                        (is_pushable_down ?y)
                        (is_you ?y)
                    )
                )
            )
            (exists ; if there is one player that has nothing to their right
                (?x - locateable ?l1 ?l2 - location)
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (down_connected ?l1 ?l2)
                    (is_empty ?l2)
                )
            )
        )        
        :effect
        (forall (?x - locateable ?l1 ?l2 - location)
            (when 
                (and
                    (is_you ?x)
                    (is_at ?x ?l1)
                    (down_connected ?l1 ?l2)
                    (or
                        (is_empty ?l2)
                        (exists (?y - locateable)
                            (and
                                (is_at ?y ?l2)
                                (or
                                    (is_pushable_down ?y)
                                    (is_you ?y)
                                )
                            )
                        )
                    )
                )
                (and
                    (is_at ?x ?l2)
                    (not (is_at ?x ?l1))
                    (moved_down ?x)
                )
            )
        )
    )

    ; Used to move pushed objects (multiple objects in the same square get pushed together (text made on pushable object))
    (:action move_right_others
    :parameters ()
    :precondition
        (exists (?x - locateable) (moved_right ?x))
   :effect 
    (forall (?x ?y - locateable ?l1 ?l2 - location)
        (when 
            (and 
                (moved_right ?x)
                (is_at ?x ?l1)
                (is_at ?y ?l1)
                (not (exists (?z - locateable) 
                        (and
                            (is_at ?z ?l2)
                            (not (is_pushable_right ?z))
                        )
                     )
                )
            )
            (and 
                (not (moved_right ?x))
                (not (is_at ?y ?l1))
                (is_at ?y ?l2)
                (moved_right ?y)
            )
        )
    )
)

(:action move_left_others
    :parameters ()
    :precondition
        (exists (?x - locateable) (moved_left ?x))
   :effect 
    (forall (?x ?y - locateable ?l1 ?l2 - location)
        (when 
            (and 
                (moved_left ?x)
                (is_at ?x ?l1)
                (is_at ?y ?l1)
                (not (exists (?z - locateable) 
                        (and
                            (is_at ?z ?l2)
                            (not (is_pushable_right ?z))
                        )
                     )
                )
            )
            (and 
                (not (moved_left ?x))
                (not (is_at ?y ?l1))
                (is_at ?y ?l2)
                (moved_left ?y)
            )
        )
    )
)

(:action move_up_others
    :parameters ()
    :precondition
        (exists (?x - locateable) (moved_up ?x))
   :effect 
    (forall (?x ?y - locateable ?l1 ?l2 - location)
        (when 
            (and 
                (moved_up ?x)
                (is_at ?x ?l1)
                (is_at ?y ?l1)
                (not (exists (?z - locateable) 
                        (and
                            (is_at ?z ?l2)
                            (not (is_pushable_right ?z))
                        )
                     )
                )
            )
            (and 
                (not (moved_up ?x))
                (not (is_at ?y ?l1))
                (is_at ?y ?l2)
                (moved_up ?y)
            )
        )
    )
)

(:action move_down_others
    :parameters ()
    :precondition
        (exists (?x - locateable) (moved_down ?x))
   :effect 
    (forall (?x ?y - locateable ?l1 ?l2 - location)
        (when 
            (and 
                (moved_down ?x)
                (is_at ?x ?l1)
                (is_at ?y ?l1)
                (not (exists (?z - locateable) 
                        (and
                            (is_at ?z ?l2)
                            (not (is_pushable_right ?z))
                        )
                     )
                )
            )
            (and 
                (not (moved_down ?x))
                (not (is_at ?y ?l1))
                (is_at ?y ?l2)
                (moved_down ?y)
            )
        )
    )
)

(:action check_right_moved_object
    :parameters()
    :precondition
        (exists (?x - locateable) (moved_right ?x))
    :effect ( and
        (forall (?x - locateable ?l - location)
            (when 
                (and
                    (moved_right ?x)
                    (is_at ?x ?l)
                    (right_edge ?l)
                )
                (not (moved_right ?x))
            )
        )
        (forall (?x - locateable ?l - location)
            (when 
                (and
                    (moved_right ?x)
                    (is_at ?x ?l)
                    (not 
                        (exists (?y - locateable)
                            (is_at ?y ?l)
                        )
                    )
                )
                (not (moved_right ?x))
            )
        )
        )
)

(:action check_left_moved_object
    :parameters()
    :precondition
        (exists (?x - locateable) (moved_left ?x))
    :effect ( and
        (forall (?x - locateable ?l - location)
            (when 
                (and
                    (moved_left ?x)
                    (is_at ?x ?l)
                    (left_edge ?l)
                )
                (not (moved_left ?x))
            )
        )
        (forall (?x - locateable ?l - location)
            (when 
                (and
                    (moved_left ?x)
                    (is_at ?x ?l)
                    (not 
                        (exists (?y - locateable)
                            (is_at ?y ?l)
                        )
                    )
                )
                (not (moved_left ?x))
            )
        )
        )
)

(:action check_up_moved_object
    :parameters()
    :precondition
        (exists (?x - locateable) (moved_up ?x))
    :effect ( and
        (forall (?x - locateable ?l - location)
            (when 
                (and
                    (moved_up ?x)
                    (is_at ?x ?l)
                    (up_edge ?l)
                )
                (not (moved_up ?x))
            )
        )
        (forall (?x - locateable ?l - location)
            (when 
                (and
                    (moved_up ?x)
                    (is_at ?x ?l)
                    (not 
                        (exists (?y - locateable)
                            (is_at ?y ?l)
                        )
                    )
                )
                (not (moved_up ?x))
            )
        )
        )
)

(:action check_down_moved_object
    :parameters()
    :precondition
        (exists (?x - locateable) (moved_down ?x))
    :effect ( and
        (forall (?x - locateable ?l - location)
            (when 
                (and
                    (moved_down ?x)
                    (is_at ?x ?l)
                    (down_edge ?l)
                )
                (not (moved_down ?x))
            )
        )
        (forall (?x - locateable ?l - location)
            (when 
                (and
                    (moved_down ?x)
                    (is_at ?x ?l)
                    (not 
                        (exists (?y - locateable)
                            (is_at ?y ?l)
                        )
                    )
                )
                (not (moved_down ?x))
            )
        )
        )
)


    ; Used to update objects to be pushable or not
    (:action update_others
        :parameters ()
        :precondition (and )
        :effect (and )
    )
    
    ; Used to update rules if there were any changes to sentence in the game
    (:action update_rules
        :parameters ()
        :precondition (and )
        :effect (and )
    )
)
