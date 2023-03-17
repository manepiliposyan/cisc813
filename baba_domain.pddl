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



        (rock_is_rock)
        (wall_is_wall)
        (flag_is_flag)
        (baba_is_baba)
        
        

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
        (relink_nouns)
        (nouns_changed)
        (sentences_checked)
        (rules_updated)
        (start)
        (temp_check)


        (is_same ?n1 ?n2 - text)
        (has_noun ?x - sprite ?n - noun)
        (has_property ?x - locateable ?p - property)

        (is_noun ?n - text)
        (is_operator ?o - text)
        (is_property ?p - text)
        (is_itself ?n - text)

        (checked_horizontal ?o - operator)
        (checked_vertical ?o - operator)
        (change_nouns ?n1 ?n2 - text)
        (give_property ?n ?p - text)
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

    ; checking all horizontal sentences
    (:action check_sentences_horizontal
        :parameters (?l1 ?l2 ?l3 - location ?middle - is)
        :precondition 
        (and 
            (properties_removed)
            (right_connected ?l2 ?l1)
            (right_connected ?l1 ?l3)
            (is_at ?middle ?l1)
            (not (checked_horizontal ?middle))
        )
        :effect 
        (and
            (forall (?left ?right - text)
                (and
                    (when 
                        (and
                            (is_at ?left ?l2)
                            (is_at ?right ?l3)
                            (is_noun ?left)
                            (is_noun ?right)
                            (is_same ?left ?right)
                        )
                        (is_itself ?left)
                    )
                    (when 
                        (and
                            (is_at ?left ?l2)
                            (is_at ?right ?l3)
                            (is_noun ?left)
                            (is_noun ?right)
                            (not (is_same ?left ?right))
                        ) 
                        (and
                            (change_nouns ?left ?right)
                        )   
                    )
                    (when 
                        (and
                            (is_at ?left ?l2)
                            (is_at ?right ?l3)
                            (is_noun ?left)
                            (is_property ?right)
                        ) 
                        (give_property ?left ?right)
                    )
                )
            )
            (checked_horizontal ?middle)
        )
    )

    ; checking all vertical sentences
    (:action check_sentences_vertical
        :parameters (?l1 ?l2 ?l3 - location ?middle - is)
        :precondition 
        (and 
            (properties_removed)
            (down_connected ?l2 ?l1)
            (down_connected ?l1 ?l3)
            (is_at ?middle ?l1)
            (not (checked_vertical ?middle))
        )
        :effect 
        (and
            (forall (?left ?right - text)
                (and
                    (when 
                        (and
                            (is_at ?left ?l2)
                            (is_at ?right ?l3)
                            (is_noun ?left)
                            (is_noun ?right)
                            (is_same ?left ?right)
                        )
                        (is_itself ?left)
                    )
                    (when 
                        (and
                            (is_at ?left ?l2)
                            (is_at ?right ?l3)
                            (is_noun ?left)
                            (is_noun ?right)
                            (not (is_same ?left ?right))
                        ) 
                        (and
                            (change_nouns ?left ?right)
                        )   
                    )
                    (when 
                        (and
                            (is_at ?left ?l2)
                            (is_at ?right ?l3)
                            (is_noun ?left)
                            (is_property ?right)
                        ) 
                        (give_property ?left ?right)
                    )
                )
            )
            (checked_vertical ?middle)
        )
    )

    ; checking operators that are on the edge (cannot have horizontal sentences)
    (:action operator_on_edge_horizontal
        :parameters (?l - location ?o - is)
        :precondition 
        (and 
            (properties_removed)
            (not (checked_horizontal ?o))
            (is_at ?o ?l)
            (or
                (right_edge ?l)
                (left_edge ?l)
            )
        )
        :effect (checked_horizontal ?o)
    )

    ; checking operators that are on the edge (cannot have vertical sentences)
    (:action operator_on_edge_vertical
        :parameters (?l - location ?o - is)
        :precondition 
        (and 
            (properties_removed)
            (not (checked_vertical ?o))
            (is_at ?o ?l)
            (or
                (up_edge ?l)
                (down_edge ?l)
            )
        )
        :effect (checked_vertical ?o)
    )

    ; for testing? when operators are not placed at a location the planner gets stuck :/
    (:action operator_missing_location
        :parameters (?o - is)
        :precondition (not (exists (?l - location) (is_at ?o ?l)))
        :effect (and (checked_horizontal ?o) (checked_vertical ?o))
    )
    
    ; making sure all sentences are checked before going to the next step
    (:action checked_all
        :parameters ()
        :precondition 
        (forall (?o - is)
            (and
                (checked_horizontal ?o)
                (checked_vertical ?o)
            )
        )
        :effect 
        (and 
            (forall (?n1 ?n2 - noun) 
                (when 
                    (and
                        (is_itself ?n1)
                        (is_same ?n1 ?n2)
                    ) 
                    (is_itself ?n2)
                )
            )
            (forall (?o - is)
                (and
                    (not (checked_horizontal ?o))
                    (not (checked_vertical ?o))
                )
            )
            (not (properties_removed))
            (sentences_checked)
        )
    )

    ; changing nouns from one into another
    (:action change_nouns
        :parameters (?n1 ?n2 - noun)
        :precondition 
        (and
            (sentences_checked)
            (not (is_itself ?n1))
            (change_nouns ?n1 ?n2)
        )
        :effect 
        (and
            (forall (?other - noun ?x - sprite)
                (and
                    ; delinking to noun1
                    (when 
                        (and 
                            (has_noun ?x ?n1)
                            (or
                                (is_same ?n1 ?other)
                                (= ?n1 ?other)
                            )
                        )
                        (and
                            (not (has_noun ?x ?other))
                            (has_noun ?x ?n2)
                        )
                    )
                )
            )
            (not (change_nouns ?n1 ?n2))
            (relink_nouns)
        )
    )

    ; for noun changes that cannot happen because there is the noun1-is-noun1 sentence
    (:action impossible_noun_change
        :parameters (?n1 ?n2 - noun)
        :precondition 
        (and
            (is_itself ?n1)
            (change_nouns ?n1 ?n2) 
        )
        :effect 
        (and
            (not (change_nouns ?n1 ?n2))
        )
    )

    ; linking sprites to all noun texts after they were changed
    (:action relink
        :parameters ()
        :precondition 
        (and 
            (relink_nouns)
            (not 
                (exists (?n1 ?n2 - noun) 
                    (change_nouns ?n1 ?n2)
                )
            )
        )
        :effect 
        (and
            (forall (?n1 ?n2 - noun ?x - sprite)
                (when 
                    (and
                        (has_noun ?x ?n1)
                        (not (has_noun ?x ?n2))
                        (is_same ?n1 ?n2) 
                    )
                    (has_noun ?x ?n2)
                ) 
            )
            (not (relink_nouns))
        )
    )
    
    ; making sure all nouns have changed before going to the next step
    (:action finished_noun_change
        :parameters ()
        :precondition 
        (and 
            (sentences_checked)
            (not 
                (exists (?n1 ?n2 - noun) 
                    (change_nouns ?n1 ?n2)
                )
            )
            (not (relink_nouns))
        )
        :effect 
        (and
            (not (sentences_checked))
            (nouns_changed)
        )
    )

    ; setup so that the initial state can be simpler
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
