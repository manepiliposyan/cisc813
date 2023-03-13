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

        (is_you ?x - sprite)
        (is_win ?x - sprite)
        (is_stop ?x - sprite)
        

        (is_rock ?x - locateable)
        (is_wall ?x - locateable)
        (is_flag ?x - locateable)
        (is_baba ?x - locateable)

        (is_same ?n1 ?n2 - noun)
        (has_noun ?x - sprite ?n - noun)
        (has_property ?x - locateable ?p - property)

        (change_nouns ?n1 ?n2 - noun)

        (rock_is_rock)
        (wall_is_wall)
        (flag_is_flag)
        (baba_is_baba)
        (is_itself ?x - noun)
        

        (is_push ?x - locateable)
        (is_pushable_right ?x - locateable)
        (is_pushable_left ?x - locateable)
        (is_pushable_up ?x - locateable)
        (is_pushable_down ?x - locateable)

        (moved_right ?x - locateable)
        (moved_left ?x - locateable)
        (moved_down ?x - locateable)
        (moved_up ?x - locateable)

        (choose_move)
        (text_moved)
        (properties_removed)
        (is_itself_checked)
        (nouns_need_change)
        (nouns_checked)
        (rules_updated)
        (start)
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
        (exists (?x - locateable) (moved_right ?x)) ; There exists an object x that has been moved to the right
   :effect 
    (forall (?x ?y - locateable ?l1 ?l2 - location) 
        (when 
            (and 
                (moved_right ?x)
                (is_at ?x ?l1)
                (is_at ?y ?l1)
                (not (exists (?z - locateable)  ; There does not exist another object z at location l2 that is not pushable to the right
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
                (not (exists (?z - locateable) ; There does not exist another object z at location l2 that is not pushable to the left
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
                (not (exists (?z - locateable) ; There does not exist another object z at location l2 that is not pushable to the up
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
                (not (exists (?z - locateable) ; There does not exist another object z at location l2 that is not pushable to the down
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
                        (exists (?y - locateable) ; There is no other object at location l, meaning x has not pushed other objects
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
    
    ; Used to update rules if there were any changes to sentence in the game
    (:action remove_properties
        :parameters ()
        :precondition (text_moved)
        :effect 
        (and
            (forall (?x - sprite ?p - property)
                (when 
                    (has_property ?x ?p) 
                    (not (has_property ?x ?p))
                )
            )
            (properties_removed)
            (not (text_moved))
        )
    )

    (:action update_x_is_x
        :parameters ()
        :precondition (properties_removed)
        :effect 
        (and
            ; go through all sentences and check if the left and right nouns are the same
            (forall (?middle - is ?left ?right ?other - noun)
                (when 
                    (and ;condition
                        (is_same ?left ?right)
                        (exists (?l1 ?l2 ?l3 - locateable) 
                            (and
                                (is_at ?left ?l1)
                                (is_at ?middle ?l2)
                                (is_at ?right ?l3)
                                (or
                                    (and
                                    (right_connected ?l1 ?l2)
                                    (right_connected ?l2 ?l3)
                                    )
                                    (and
                                    (down_connected ?l1 ?l2)
                                    (down_connected ?l2 ?l3)
                                    )
                                )
                            )
                        )
                        ; this allows us to make all of the nouns of the same type have the predicate 'is_itself'
                        ; this is because we need to know if other nouns of the same type get used in a different sentence
                        (or
                            (is_same ?other ?left)
                            (= ?left ?other)
                        )
                    )
                    (is_itself ?other)
                )
            )
            (not (properties_removed))
            (is_itself_checked)
        )
    )

    ; (:action update_x_is_y
    ;     :parameters ()
    ;     :precondition (is_itself_checked)
    ;     :effect 
    ;     (and
    ;         ; looking for all sentences with two nouns on either side (that are not the same)
    ;         (forall (?middle - is ?left ?right - noun ?l1 ?l2 ?l3 - location)
    ;             (when 
    ;                 (and ;condition
    ;                     (not (is_itself ?left))
    ;                     (not (is_same ?left ?right))
    ;                     (is_at ?left ?l1)
    ;                     (is_at ?middle ?l2)
    ;                     (is_at ?right ?l3)
    ;                     (or
    ;                         (and
    ;                         (right_connected ?l1 ?l2)
    ;                         (right_connected ?l2 ?l3)
    ;                         )
    ;                         (and
    ;                         (down_connected ?l1 ?l2)
    ;                         (down_connected ?l2 ?l3)
    ;                         )
    ;                     )
    ;                 )
    ;                 ; flag the nouns to change
    ;                 (and
    ;                     (change_nouns ?left ?right)
    ;                     (nouns_need_change)
    ;                 )
    ;             )
    ;         )
    ;         (not (is_itself_checked))
    ;         (nouns_checked)
    ;     )
    ; )

    ; ; if any sentences were noun1-is-noun2, change all sprites of the first noun to the second
    ; (:action change_nouns
    ;     :parameters ()
    ;     :precondition (nouns_need_change)
    ;     :effect 
    ;     (and
    ;         ; n3 is needed because we need to delink sprites to all nouns of type noun1, and link to all types of noun2
    ;         (forall (?n1 ?n2 ?n3 - noun ?x - sprite)
    ;             (and
    ;                 ; delinking to noun1
    ;                 (when 
    ;                     (and 
    ;                         (change_nouns ?n1 ?n2)
    ;                         (has_noun ?x ?n1)
    ;                         (or
    ;                             (is_same ?n1 ?n3)
    ;                             (= ?n1 ?n3)
    ;                         )
    ;                     )
    ;                     (not (has_noun ?x ?n3))
    ;                 )
    ;                 ; linking to noun2
    ;                 (when 
    ;                     (and 
    ;                         (change_nouns ?n1 ?n2)
    ;                         (has_noun ?x ?n2)
    ;                         (or
    ;                             (is_same ?n2 ?n3)
    ;                             (= ?n2 ?n3)
    ;                         )
    ;                     )
    ;                     (has_noun ?x ?n3)
    ;                 )
    ;             )
    ;         ) 
    ;     )
    ; )
    

    ; (:action add_properties
    ;     :parameters ()
    ;     :precondition (and (nouns_checked) (not (nouns_need_change)))
    ;     :effect 
    ;     (and
    ;         (forall (?middle - is ?left - noun ?right - property ?l1 ?l2 ?l3 - location) 
    ;             (when 
    ;                 (and ;condition
    ;                     (is_at ?left ?l1)
    ;                     (is_at ?middle ?l2)
    ;                     (is_at ?right ?l3)
    ;                     (or
    ;                         (and
    ;                         (right_connected ?l1 ?l2)
    ;                         (right_connected ?l2 ?l3)
    ;                         )
    ;                         (and
    ;                         (down_connected ?l1 ?l2)
    ;                         (down_connected ?l2 ?l3)
    ;                         )
    ;                     )
    ;                 ) 
    ;                 (forall (?x - sprite)
    ;                     (when 
    ;                         (has_noun ?x ?left) 
    ;                         (has_property ?x ?right)
    ;                     ) 
    ;                 )
    ;             )
    ;         )
    ;         (not (nouns_checked))
    ;         (rules_updated)
    ;     )
    ; )

    (:action setup
        :parameters ()
        :precondition (start)
        :effect 
        (and
            (forall (?n1 ?n2 - noun ?x - sprite)
                (when 
                    (and
                        (has_noun ?x ?n1)
                        (is_same ?n1 ?n2) 
                    )
                    (has_noun ?x ?n2)
                ) 
            )
            (not (start))
            (text_moved)
        )
    )


)
