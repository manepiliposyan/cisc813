(define (domain baba)
    (:requirements :conditional-effects :disjunctive-preconditions :negative-preconditions :equality :adl :typing)

    (:types
        locateable location direction - object
        sprite text - locateable
        noun operator property - text
        baba rock wall flag - noun
        is - operator
        you push stop win - property
    )
    
    (:constants
        text_push - push
        right left up down - direction
    )

    (:predicates
        (connected ?l1 ?l2 - location ?dir - direction)

        (edge ?l - location ?dir - direction)

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

        (chosen_dir ?dir - direction)

        (is_pushable ?x - locateable ?dir - direction)
        (moved ?x - locateable ?dir - direction)
        (cant_move ?x - sprite)

        (choose_move)
        (players_moved)
        (text_moved)
        (properties_removed)
        (is_itself_checked)
        (nouns_need_change)
        (relink_nouns)
        (nouns_changed)
        (sentences_checked)
        (properties_given)
        (moveable_given)
        (spreading)
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

        (push_checked ?x - locateable)
        (check ?x - locateable ?dir - direction)

        (not_pushable ?x - locateable ?dir - direction)
        (moveable ?x - locateable ?dir - direction)
    )

    (:action choose_dir
        :parameters (?dir - direction)
        :precondition 
        (and 
            (choose_move)
            (exists (?x - sprite) (moveable ?x ?dir))
        )
        :effect 
        (and
            (chosen_dir ?dir)
        )
    )

    ; (:action move_players
    ;     :parameters (?x - sprite ?y - you ?l1 ?l2 - location ?dir - direction)
    ;     :precondition 
    ;     (and 
    ;         ;(chosen_dir ?dir)
    ;         (has_property ?x ?y)
    ;         (is_at ?x ?l1)
    ;         (connected ?l1 ?l2 ?dir)
    ;         (not (moved ?x ?dir))
    ;     )
    ;     :effect 
    ;     (and 
    ;         (when 
    ;             (not 
    ;                 (exists (?x2 - locateable)
    ;                     (and
    ;                         (is_at ?x2 ?l2)
    ;                         (not_pushable ?x2 ?dir)
    ;                     )
    ;                 )
    ;             ) 
    ;             (and
    ;                 (not (is_at ?x ?l1))
    ;                 (is_at ?x ?l2)
    ;                 (players_moved)
    ;             )
    ;         )
    ;         (moved ?x ?dir)
    ;     )
    ; )

    (:action cannot_move
        :parameters (?x - sprite ?y - you ?dir - direction)
        :precondition 
        (and
            (chosen_dir ?dir) 
            (has_property ?x ?y)
            (not (moveable ?x ?dir))
        )
        :effect 
        (and 
            (cant_move ?x)
        )
    )
    
    ; (:action test_action
    ;     :parameters (?x - sprite ?l1 ?l2 - location ?dir - direction)
    ;     :precondition 
    ;     (and 
    ;         (chosen_dir ?dir)
    ;     )
    ;     :effect 
    ;     (and 
    ;         (moved ?x ?dir)
    ;     )
    ; )
    

    (:action move_player
        :parameters (?x - sprite ?l1 ?l2 - location ?dir - direction)
        :precondition 
        (and
            (chosen_dir ?dir)
            (is_at ?x ?l1)
            (connected ?l1 ?l2 ?dir)
            (moveable ?x ?dir)
        )
        :effect 
        (and 
            (not (is_at ?x ?l1))
            (is_at ?x ?l2)
            (moved ?x ?dir)
        )
    )

    ; (:action check_moved_player
    ;     :parameters (?dir - direction)
    ;     :precondition 
    ;     (and 
    ;         (chosen_dir ?dir)
    ;         (not
    ;             (exists (?x - sprite ?y - you) 
    ;                 (and
    ;                     (has_property ?x ?y)
    ;                     (not (moved ?x ?dir))
    ;                     (not (cant_move ?x))
    ;                 )
    ;             )
    ;         )
    ;     )
    ;     :effect 
    ;     (and 
    ;         (not (chosen_dir ?dir))
    ;         (forall (?x - sprite) 
    ;             (not (cant_move ?x))
    ;         )
    ;         (players_moved)
    ;     )
    ; )
    
    

    ; (:action all_moved
    ;     :parameters (?dir - direction)
    ;     :precondition 
    ;     (and
    ;         (choose_move)
    ;         (chosen_dir ?dir)
    ;         (not 
    ;             (exists (?x - sprite ?y - you)
    ;                 (and
    ;                     (has_property ?x ?y)
    ;                     (not (moved ?x ?dir))
    ;                 )
    ;             )
    ;         )
    ;     )
    ;     :effect 
    ;     (and 
    ;         (when 
    ;             (not (players_moved)) 
    ;             (forall (?x - sprite) 
    ;                 (not (moved ?x ?dir))
    ;             )
    ;         )
    ;         (when 
    ;             (players_moved) 
    ;             (choose_move)
    ;         )
    ;         (not (chosen_dir ?dir))
    ;     )
    ; )
    
    ; Used to move the player (objects that have is_you)
    ; (:action move
    ;     :parameters (?dir - direction)
    ;     :precondition
    ;     (or
    ;         (exists ; if there is one player that has a pushable or background object to their right
    ;             (?x - sprite ?y - locateable ?l1 ?l2 - location) 
    ;             (and
    ;                 (is_you ?x)
    ;                 (is_at ?x ?l1)
    ;                 (is_at ?y ?l2)
    ;                 (connected ?l1 ?l2 ?dir)
    ;                 (or
    ;                     (is_pushable ?y ?dir)
    ;                     (is_you ?y)
    ;                 )
    ;             )
    ;         )
    ;         (exists ; if there is one player that has nothing to their right
    ;             (?x - locateable ?l1 ?l2 - location)
    ;             (and
    ;                 (is_you ?x)
    ;                 (is_at ?x ?l1)
    ;                 (connected ?l1 ?l2 ?dir)
    ;                 (is_empty ?l2)
    ;             )
    ;         )
    ;     )
    ;     :effect 
    ;     (forall (?x - locateable ?l1 ?l2 - location)
    ;         (when 
    ;             (and
    ;                 (is_you ?x)
    ;                 (is_at ?x ?l1)
    ;                 (connected ?l1 ?l2 ?dir)
    ;                 (or
    ;                     (is_empty ?l2)
    ;                     (exists (?y - locateable)
    ;                         (and
    ;                             (is_at ?y ?l2)
    ;                             (or
    ;                                 (is_pushable ?y ?dir)
    ;                                 (is_you ?y)
    ;                             )
    ;                         )
    ;                     )
    ;                 )
    ;             )
    ;             (and
    ;                 (is_at ?x ?l2)
    ;                 (not (is_at ?x ?l1))
    ;                 (moved ?x ?dir)
    ;             )
    ;         )
    ;     )
    ; )

    ; Used to move pushed objects (multiple objects in the same square get pushed together (text made on pushable object))
;     (:action move_others
;     :parameters (?dir - direction)
;     :precondition
;         (exists (?x - locateable) (moved ?x ?dir)) ; There exists an object x that has been moved to the right
;    :effect 
;     (forall (?x ?y - locateable ?l1 ?l2 - location) 
;         (when 
;             (and 
;                 (moved ?x ?dir)
;                 (is_at ?x ?l1)
;                 (is_at ?y ?l1)
;                 (not (exists (?z - locateable)  ; There does not exist another object z at location l2 that is not pushable to the right
;                         (and
;                             (is_at ?z ?l2)
;                             (not (is_pushable ?z ?dir))
;                         )
;                      )
;                 )
;             )
;             (and 
;                 (not (moved ?x ?dir))
;                 (not (is_at ?y ?l1))
;                 (is_at ?y ?l2)
;                 (moved ?y ?dir)
;             )
;         )
;     )
; )

; (:action check_moved_object
;     :parameters(?dir - direction)
;     :precondition
;         (exists (?x - locateable) (moved ?x ?dir))
;     :effect ( and
;         (forall (?x - locateable ?l - location)
;             (when 
;                 (and
;                     (moved ?x ?dir)
;                     (is_at ?x ?l)
;                     (edge ?l ?dir)
;                 )
;                 (not (moved ?x ?dir))
;             )
;         )
;         (forall (?x - locateable ?l - location)
;             (when 
;                 (and
;                     (moved ?x ?dir)
;                     (is_at ?x ?l)
;                     (not 
;                         (exists (?y - locateable) ; There is no other object at location l, meaning x has not pushed other objects
;                             (is_at ?y ?l)
;                         )
;                     )
;                 )
;                 (not (moved ?x ?dir))
;             )
;         )
;         )
; )

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
            (connected ?l2 ?l1 right)
            (connected ?l1 ?l3 right)
            (is_at ?middle ?l1)
            (not (checked_horizontal ?middle))
        )
        :effect 
        (and
            (forall (?left_ ?right_ - text)
                (and
                    (when 
                        (and
                            (is_at ?left_ ?l2)
                            (is_at ?right_ ?l3)
                            (is_noun ?left_)
                            (is_noun ?right_)
                            (is_same ?left_ ?right_)
                        )
                        (is_itself ?left_)
                    )
                    (when 
                        (and
                            (is_at ?left_ ?l2)
                            (is_at ?right_ ?l3)
                            (is_noun ?left_)
                            (is_noun ?right_)
                            (not (is_same ?left_ ?right_))
                        ) 
                        (and
                            (change_nouns ?left_ ?right_)
                        )   
                    )
                    (when 
                        (and
                            (is_at ?left_ ?l2)
                            (is_at ?right_ ?l3)
                            (is_noun ?left_)
                            (is_property ?right_)
                        ) 
                        (give_property ?left_ ?right_)
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
            (connected ?l2 ?l1 down)
            (connected ?l1 ?l3 down)
            (is_at ?middle ?l1)
            (not (checked_vertical ?middle))
        )
        :effect 
        (and
            (forall (?left_ ?right_ - text)
                (and
                    (when 
                        (and
                            (is_at ?left_ ?l2)
                            (is_at ?right_ ?l3)
                            (is_noun ?left_)
                            (is_noun ?right_)
                            (is_same ?left_ ?right_)
                        )
                        (is_itself ?left_)
                    )
                    (when 
                        (and
                            (is_at ?left_ ?l2)
                            (is_at ?right_ ?l3)
                            (is_noun ?left_)
                            (is_noun ?right_)
                            (not (is_same ?left_ ?right_))
                        ) 
                        (and
                            (change_nouns ?left_ ?right_)
                        )   
                    )
                    (when 
                        (and
                            (is_at ?left_ ?l2)
                            (is_at ?right_ ?l3)
                            (is_noun ?left_)
                            (is_property ?right_)
                        ) 
                        (give_property ?left_ ?right_)
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
                (edge ?l right)
                (edge ?l left)
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
                (edge ?l up)
                (edge ?l down)
            )
        )
        :effect (checked_vertical ?o)
    )

    ; for testing? when operators are not placed at a location the planner gets stuck :/
    (:action operator_missing_location
        :parameters (?o - is)
        :precondition 
        (and 
            (properties_removed)
            (not (exists (?l - location) (is_at ?o ?l)))
        )
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
    
    ; giving sprites the proper properties
    (:action add_properties
        :parameters (?n - noun ?p - property)
        :precondition 
        (and 
            (nouns_changed)
            (give_property ?n ?p)
        )
        :effect 
        (and
            (forall (?x - sprite)
                (when 
                    (has_noun ?x ?n) 
                    (has_property ?x ?p)
                )
            )
            (not (give_property ?n ?p))
        )
    )

    ; going to next step once all the properties have been given
    (:action properties_added
        :parameters ()
        :precondition 
        (and 
            (nouns_changed)
            (not 
                (exists (?n - noun ?p - property) 
                    (give_property ?n ?p)
                )
            )
        )
        :effect 
        (and
            (not (nouns_changed))
            (properties_given)
        )
    )

    ; giving all sprites that are you moveability in all directions
    (:action give_moveable
        :parameters ()
        :precondition 
        (and
            (properties_given)
        )
        :effect 
        (and 
            (forall (?x - sprite)
                (when 
                    (exists (?y - you)
                        (has_property ?x ?y)
                    ) 
                    (and
                        (moveable ?x right)
                        (moveable ?x left)
                        (moveable ?x up)
                        (moveable ?x down)
                    )
                )
            )
            (not (properties_given))
            (moveable_given)
        )
    )
    
    ; remove moveable to all you objects on the edges of the grid
    (:action edge_check_you
        :parameters (?x - locateable ?l - location ?y - you)
        :precondition 
        (and
            (moveable_given)
            (has_property ?x ?y)
            (is_at ?x ?l)
            (not (push_checked ?x))
        )
        :effect 
        (and
            (when 
                (edge ?l right)
                (and 
                    (not (moveable ?x right))
                )
            )
            (when 
                (edge ?l left) 
                (and
                    (not (moveable ?x left))
                )
            )
            (when 
                (edge ?l up) 
                (and
                    (not (moveable ?x up))
                )
            )
            (when 
                (edge ?l down) 
                (and
                    (not (moveable ?x down))
                )
            )
            (push_checked ?x)
        )
    )

    ; add checks to all pushable objects on the edges of the grid
    (:action edge_check_push
        :parameters (?x - locateable ?l - location ?p - push)
        :precondition 
        (and
            (moveable_given)
            (has_property ?x ?p)
            (is_at ?x ?l)
            (not (push_checked ?x))
        )
        :effect 
        (and
            (when 
                (edge ?l right)
                (and 
                    (check ?x left)
                    (not_pushable ?x right)
                )
            )
            (when 
                (edge ?l left) 
                (and
                    (check ?x right)
                    (not_pushable ?x left)
                )
            )
            (when 
                (edge ?l up) 
                (and
                    (check ?x down)
                    (not_pushable ?x up)
                )
            )
            (when 
                (edge ?l down) 
                (and
                    (check ?x up)
                    (not_pushable ?x down)
                )
            )
            (push_checked ?x)
        )
    )

    ; ; giving checks in all directions to sprites with the stop attribute
    (:action stop_check
        :parameters (?x - locateable ?s - stop)
        :precondition 
        (and
            (moveable_given)
            (has_property ?x ?s)
            (not (exists (?p - push) (has_property ?x ?p)))
            (not (push_checked ?x))
        )
        :effect 
        (and
            (forall (?dir - direction)
                (and
                    (check ?x ?dir)
                    (not_pushable ?x ?dir)
                )
            )
            (push_checked ?x)
        )
    )

    ; ; this simplifies the check in begin_spread so it doesnt have to go through a bunch of stuff in the forall
    (:action others_check
        :parameters (?x - locateable)
        :precondition 
        (and 
            (moveable_given)
            (not (push_checked ?x))
            (not (exists (?p - push) (has_property ?x ?p)))
            (not (exists (?s - stop) (has_property ?x ?s)))
            (not (exists (?y - you) (has_property ?x ?y)))
        )
        :effect 
        (and
            (push_checked ?x)
        )
    )

    ; ; for locatables wihtout location (due to testing and also teh text_push constant)
    (:action non_location_check
        :parameters (?x - locateable)
        :precondition 
        (and
            (moveable_given)
            (not (push_checked ?x))
            (not (exists (?l - location) (is_at ?x ?l)))
        )
        :effect 
        (and
            (push_checked ?x)
        )
    )
    
    ; ; when all the sprites on the edges or all the sprites with 'stop' have been checked, begin spreading the pushable 
    (:action begin_spread
        :parameters ()
        :precondition 
        (and
            (moveable_given)
            (forall (?x - locateable)
                (push_checked ?x)
            )
        )
        :effect 
        (and
            (forall (?x - locateable)
                (not (push_checked ?x))
            )
            (spreading)
            (not (moveable_given))
        )
    )

    ; spread the pushing using the check-direction
    (:action spread_push_obj
        :parameters (?x ?y - locateable ?l1 ?l2 - location ?check_dir ?opposite_dir - direction)
        :precondition 
        (and 
            (spreading)
            (is_at ?x ?l1)
            (check ?x ?check_dir)
            (connected ?l1 ?l2 ?check_dir)
            (connected ?l2 ?l1 ?opposite_dir)
            (is_at ?y ?l2)
        )
        :effect 
        (and
            (not (check ?x ?check_dir))
            (when 
                (exists (?p - push)
                    (has_property ?y ?p)
                ) 
                (and
                    (check ?y ?check_dir)
                    (not_pushable ?y ?opposite_dir)
                )
            )
            (when 
                (exists (?y_prop - you) 
                    (has_property ?y ?y_prop)
                ) 
                (not (moveable ?y ?opposite_dir))
            )
        )
    )

    (:action spread_push_edge
        :parameters (?x - locateable ?l - location ?dir - direction)
        :precondition 
        (and 
            (spreading)
            (is_at ?x ?l)
            (check ?x ?dir)
            (edge ?l ?dir)
        )
        :effect 
        (and
            (not (check ?x ?dir))
        )
    )

    (:action spread_push_empty
        :parameters (?x - locateable ?l1 ?l2 - location ?dir - direction)
        :precondition 
        (and
            (spreading)
            (is_at ?x ?l1)
            (check ?x ?dir)
            (connected ?l1 ?l2 ?dir)
            (is_empty ?l2)
        )
        :effect 
        (and
            (not (check ?x ?dir))
        )
    )

    (:action finished_spreading
        :parameters ()
        :precondition 
        (and 
            (spreading)
            (not (exists (?x - locateable ?dir - direction) (check ?x ?dir)))
        )
        :effect 
        (and 
            (not (spreading))
            (choose_move)
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
            (forall (?t - text)
                (has_property ?t text_push)
            )
            (forall (?l - location)
                (when 
                    (not 
                        (exists (?x - locateable)
                            (is_at ?x ?l)
                        )
                    ) 
                    (is_empty ?l)
                )
            )
            (not (start))
            (text_moved)
        )
    )
)