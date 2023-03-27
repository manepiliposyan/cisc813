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
        ; problem dependent constants
        ;python script needed
        L_00 L_01 L_02 L_03 L_04 L_05 L_10 L_11 L_12 L_13 L_14 L_15 L_20 L_21 L_22 L_23 L_24 L_25 L_30 L_31 L_32 L_33 L_34 L_35 L_40 L_41 L_42 L_43 L_44 L_45 L_50 L_51 L_52 L_53 L_54 L_55 - location
        x1 x2 x3 x4 - sprite
        is1 is2 is3 - is
        y1 - you
        p1 - push
        s1 - stop
        ;g1 - win
        b1 - baba
        r1 - rock
        w1 - wall
        ;f1 - flag
    )

    (:predicates
        (connected ?l1 ?l2 - location ?dir - direction)

        (edge ?l - location ?dir - direction)
        (is_text ?t - locateable)

        (is_empty ?l1 - location)

        (is_at ?x - locateable ?l1 - location)

        (chosen_dir ?dir - direction)

        (moved ?x - locateable ?dir - direction)
        (has_moved ?x - locateable)
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
        (updating_movement)
        (moveable_given)
        (spreading)
        (start)
        (temp_check)


        (is_same ?t1 ?t2 - text)
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

        (move_checked ?x - sprite)

        (not_pushable ?x - locateable ?dir - direction)
        (moveable ?x - locateable ?dir - direction)
    )

    (:action choose_dir
        :parameters (?dir - direction)
        :precondition 
        (and 
            (choose_move)
            ;(exists (?x - sprite) (moveable ?x ?dir))
            ;python script needed
            (or
                (moveable x1 ?dir)
                (moveable x2 ?dir)
                (moveable x3 ?dir)
                (moveable x4 ?dir)
            )
        )
        :effect 
        (and
            (not (choose_move))
            (chosen_dir ?dir)
        )
    )

    (:action cannot_move
        :parameters (?x - sprite ?dir - direction)
        :precondition 
        (and
            (not (players_moved))
            (chosen_dir ?dir) 
            (has_property ?x y1)
            (not (moveable ?x ?dir))
        )
        :effect 
        (and 
            (cant_move ?x)
            (move_checked ?x)
        )
    )

    (:action move_player
        :parameters (?x - sprite ?l1 ?l2 - location ?dir - direction)
        :precondition 
        (and
            (not (players_moved))
            (chosen_dir ?dir)
            (is_at ?x ?l1)
            (connected ?l1 ?l2 ?dir)
            (moveable ?x ?dir)
            (not (moved ?x ?dir))
        )
        :effect 
        (and 
            (not (is_at ?x ?l1))
            (is_at ?x ?l2)
            (moved ?x ?dir)
            (move_checked ?x)
        )
    )

    (:action other_sprite_move
        :parameters (?x - sprite ?dir - direction)
        :precondition 
        (and 
            (not (players_moved))
            (chosen_dir ?dir)
            ; (not (exists (?y - you) (has_property ?x ?y)))
            ;python script needed (not needed since will always be connected to y1)
            (not (has_property ?x y1))
        )
        :effect 
        (and 
            (move_checked ?x)
        )
    )
    

    (:action check_moved_player
        :parameters (?dir - direction)
        :precondition 
        (and 
            (chosen_dir ?dir)
            ; (forall (?x - sprite) (move_checked ?x))
            ;python script needed
            (move_checked x1)
            (move_checked x2)
            (move_checked x3)
            (move_checked x4)
        )
        :effect 
        (and 
            (forall (?x - sprite) 
                (and
                    (not (cant_move ?x))
                    (not (move_checked ?x))
                )
            )
            (players_moved)
        )
    )

    ; spread the pushing using the check-direction
    (:action move_obj
        :parameters (?x ?y - locateable ?l1 ?l2 - location ?dir - direction)
        :precondition 
        (and 
            (players_moved)
            (is_at ?x ?l1)
            (is_at ?y ?l1)
            (not (= ?x ?y))
            (moved ?x ?dir)
            (has_property ?y text_push)
            (connected ?l1 ?l2 ?dir)
        )
        :effect 
        (and
            (not (is_at ?y ?l1))
            (is_at ?y ?l2)
            (moved ?y ?dir)
            (has_moved ?y)
            (when (is_text ?y) (text_moved))
            (forall (?other - locateable)
                (and
                    (when 
                        (and
                            (is_at ?other ?l1)
                            (has_property ?other text_push)
                            (not (has_moved ?other))
                            (not (is_text ?other))
                            
                        ) 
                        (and
                            (not (is_at ?other ?l1))
                            (is_at ?other ?l2)
                            (has_moved ?other)
                        )
                    )
                    (when 
                        (and
                            (is_at ?other ?l1)
                            (has_property ?other text_push)
                            (not (has_moved ?other))
                            (is_text ?other)
                            
                        ) 
                        (and
                            (not (is_at ?other ?l1))
                            (is_at ?other ?l2)
                            (has_moved ?other)
                            (text_moved)
                        )
                    )
                )
            )
            (not (moved ?x ?dir))
        )
    )

    (:action moved_edge
        :parameters (?x - locateable ?l - location ?dir - direction)
        :precondition 
        (and 
            (players_moved)
            (is_at ?x ?l)
            (moved ?x ?dir)
            (edge ?l ?dir)
        )
        :effect 
        (and
            (not (moved ?x ?dir))
        )
    )

    (:action move_empty
        :parameters (?x - locateable ?l1 - location ?dir - direction)
        :precondition 
        (and
            (players_moved)
            (is_at ?x ?l1)
            (moved ?x ?dir)
            (is_empty ?l1)
        )
        :effect 
        (and
            (not (moved ?x ?dir))
        )
    )

    (:action movement_finished
        :parameters (?dir - direction)
        :precondition 
        (and 
            (players_moved)
            (chosen_dir ?dir)
            ;python script needed
            (not (moved x1 ?dir))
            (not (moved x2 ?dir))
            (not (moved x3 ?dir))
            (not (moved x4 ?dir))
            (not (moved is1 ?dir))
            (not (moved is2 ?dir))
            (not (moved is3 ?dir))
            (not (moved b1 ?dir))
            (not (moved r1 ?dir))
            (not (moved w1 ?dir))
            (not (moved y1 ?dir))
            (not (moved p1 ?dir))
            (not (moved s1 ?dir))
        )
        :effect 
        (and
            (not (chosen_dir ?dir))
            (not (players_moved))
            (when (not (text_moved)) (properties_given))
            (forall (?x - locateable) (not (has_moved ?x)))
            (temp_check)
        )
    )
    
    ; Used to update rules if there were any changes to sentence in the game
    (:action remove_properties
        :parameters ()
        :precondition (and (text_moved) (not (players_moved)))
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

    ; for testing? when operators are not placed at a location the planner gets stuck :/ (should never be needed for real problems)
    ; (:action operator_missing_location
    ;     :parameters (?o - is)
    ;     :precondition 
    ;     (and 
    ;         (properties_removed)
    ;         (not (exists (?l - location) (is_at ?o ?l)))
    ;     )
    ;     :effect (and (checked_horizontal ?o) (checked_vertical ?o))
    ; )
    
    ; making sure all sentences are checked before going to the next step
    (:action checked_all
        :parameters ()
        :precondition 
        (and
            ; (forall (?o - operator) 
            ;     (and
            ;         (checked_horizontal ?o)
            ;         (checked_vertical ?o)
            ;     )
            ; )
            ;python script needed
            (checked_horizontal is1)
            (checked_vertical is1)
            (checked_horizontal is2)
            (checked_vertical is2)
            (checked_horizontal is3)
            (checked_vertical is3)
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
                            (is_same ?n1 ?other)
                        )
                        (and
                            (not (has_noun ?x ?other))
                            (has_noun ?x ?n2)
                        )
                    )
                    (when 
                        (and 
                            (has_noun ?x ?n1)
                            (= ?n1 ?other)
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
            ; not sure if this is needed here
            ; (not 
            ;     (exists (?n1 ?n2 - noun) 
            ;         (change_nouns ?n1 ?n2)
            ;     )
            ; )
            
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
            ; (not 
            ;     (exists (?n1 ?n2 - noun) 
            ;         (change_nouns ?n1 ?n2)
            ;     )
            ; )
            ;need python script
            (not (change_nouns b1 r1))
            (not (change_nouns b1 w1))
            (not (change_nouns r1 b1))
            (not (change_nouns r1 w1))
            (not (change_nouns w1 b1))
            (not (change_nouns w1 r1))
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
            (forall (?x - sprite ?p_other - property)
                (and
                    (when
                        (and 
                            (has_noun ?x ?n)
                            (is_same ?p ?p_other)
                        )
                        (has_property ?x ?p_other)
                    )
                    (when
                        (and 
                            (has_noun ?x ?n)
                            (= ?p ?p_other)
                        )
                        (has_property ?x ?p_other)
                    )
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
            ; (not 
            ;     (exists (?n - noun ?p - property) 
            ;         (give_property ?n ?p)
            ;     )
            ; )
            ;need python script
            (not (give_property b1 y1))
            (not (give_property b1 p1))
            (not (give_property b1 s1))
            (not (give_property r1 y1))
            (not (give_property r1 p1))
            (not (give_property r1 s1))
            (not (give_property w1 y1))
            (not (give_property w1 p1))
            (not (give_property w1 s1))
        )
        :effect 
        (and
            (not (nouns_changed))
            (properties_given)
        )
    )

    (:action remove_movement
        :parameters ()
        :precondition (properties_given)
        :effect 
        (and
            (forall (?l - location) 
                (is_empty ?l)
            )
            (forall (?x - locateable ?dir - direction)
                (and
                    (not (moveable ?x ?dir))
                    (not (not_pushable ?x ?dir))
                )
            )
            (updating_movement)
            (not (properties_given))
        )
    )
    

    ; giving all sprites that are you moveability in all directions
    (:action give_moveable
        :parameters ()
        :precondition 
        (and
            (updating_movement)
        )
        :effect 
        (and 
            (forall (?x - sprite)
                ; (when 
                ;     (exists (?y - you)
                ;         (has_property ?x ?y)
                ;     ) 
                ;     (and
                ;         (moveable ?x right)
                ;         (moveable ?x left)
                ;         (moveable ?x up)
                ;         (moveable ?x down)
                ;     )
                ; )
                ;need python script (maybe not because will always have y1)
                (and
                    (when 
                        (has_property ?x y1) 
                        (and
                            (moveable ?x right)
                            (moveable ?x left)
                            (moveable ?x up)
                            (moveable ?x down)
                        )
                    )
                )
            )
            (not (updating_movement))
            (moveable_given)
        )
    )
    
    ; remove moveable to all you objects on the edges of the grid
    (:action edge_check_you
        :parameters (?x - locateable ?l - location)
        :precondition 
        (and
            (moveable_given)
            (has_property ?x y1)
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
            (not (is_empty ?l))
            (push_checked ?x)
        )
    )

    ; add checks to all pushable objects on the edges of the grid
    (:action edge_check_push
        :parameters (?x - locateable ?l - location)
        :precondition 
        (and
            (moveable_given)
            (has_property ?x text_push)
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
            (not (is_empty ?l))
            (push_checked ?x)
        )
    )

    ; ; giving checks in all directions to sprites with the stop attribute
    (:action stop_check
        :parameters (?x - locateable ?s - stop ?l - location)
        :precondition 
        (and
            (moveable_given)
            (has_property ?x ?s)
            (is_at ?x ?l)
            ;(not (exists (?p - push) (has_property ?x ?p)))
            ;need python script (maybe not becasue all will have property text_push)
            (not (has_property ?x text_push))
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
            (not (is_empty ?l))
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
            (not (has_property ?x text_push))
            (not (has_property ?x y1))
            ; (not (exists (?p - push) (has_property ?x ?p)))
            ; (not (exists (?s - stop) (has_property ?x ?s)))
            ; (not (exists (?y - you) (has_property ?x ?y)))
            ;need python script
            (not (has_property ?x s1))
            
        )
        :effect 
        (and
            (push_checked ?x)
        )
    )

    ; for locatables without location (due to testing and also teh text_push constant) (should not be needed)
    ; (:action non_location_check
    ;     :parameters (?x - locateable)
    ;     :precondition 
    ;     (and
    ;         (moveable_given)
    ;         (not (push_checked ?x))
    ;         (not (exists (?l - location) (is_at ?x ?l)))
    ;     )
    ;     :effect 
    ;     (and
    ;         (push_checked ?x)
    ;     )
    ; )
    
    ; ; when all the sprites on the edges or all the sprites with 'stop' have been checked, begin spreading the pushable 
    (:action begin_spread
        :parameters ()
        :precondition 
        (and
            (moveable_given)
            ; (forall (?x - locateable)
            ;     (push_checked ?x)
            ; )
            ;need python script
            (push_checked x1)
            (push_checked x2)
            (push_checked x3)
            (push_checked x4)
            (push_checked is1)
            (push_checked is2)
            (push_checked is3)
            (push_checked y1)
            (push_checked s1)
            (push_checked p1)
            (push_checked b1)
            (push_checked r1)
            (push_checked w1)
        )
        :effect 
        (and
            (forall (?x - locateable)
                (not (push_checked ?x))
            )
            (push_checked text_push)
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
            ; (when 
            ;     (exists (?p - push)
            ;         (has_property ?y ?p)
            ;     ) 
            ;     (and
            ;         (check ?y ?check_dir)
            ;         (not_pushable ?y ?opposite_dir)
            ;     )
            ; )
            ;need python script

            ; (when 
            ;     (exists (?y_prop - you) 
            ;         (has_property ?y ?y_prop)
            ;     ) 
            ;     (not (moveable ?y ?opposite_dir))
            ; )

            (when 
                (has_property ?y text_push) 
                (and
                    (check ?y ?check_dir)
                    (not_pushable ?y ?opposite_dir)
                )
            )
            (when 
                (has_property ?y y1)
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
            ; (not (exists (?x - locateable ?dir - direction) (check ?x ?dir)))
            ;need python script
            (not (check x1  right))
            (not (check x2  right))
            (not (check x3  right))
            (not (check x4  right))
            (not (check is1 right))
            (not (check is2 right))
            (not (check is3 right))
            (not (check y1  right))
            (not (check s1  right))
            (not (check p1  right))
            (not (check b1  right))
            (not (check r1  right))
            (not (check w1  right))

            (not (check x1  left))
            (not (check x2  left))
            (not (check x3  left))
            (not (check x4  left))
            (not (check is1 left))
            (not (check is2 left))
            (not (check is3 left))
            (not (check y1  left))
            (not (check s1  left))
            (not (check p1  left))
            (not (check b1  left))
            (not (check r1  left))
            (not (check w1  left))

            (not (check x1  up))
            (not (check x2  up))
            (not (check x3  up))
            (not (check x4  up))
            (not (check is1 up))
            (not (check is2 up))
            (not (check is3 up))
            (not (check y1  up))
            (not (check s1  up))
            (not (check p1  up))
            (not (check b1  up))
            (not (check r1  up))
            (not (check w1  up))

            (not (check x1  down))
            (not (check x2  down))
            (not (check x3  down))
            (not (check x4  down))
            (not (check is1 down))
            (not (check is2 down))
            (not (check is3 down))
            (not (check y1  down))
            (not (check s1  down))
            (not (check p1  down))
            (not (check b1  down))
            (not (check r1  down))
            (not (check w1  down))
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
            ; (forall (?l - location)
            ;     (when 
            ;         (not 
            ;             (exists (?x - locateable)
            ;                 (is_at ?x ?l)
            ;             )
            ;         ) 
            ;         (is_empty ?l)
            ;     )
            ; )
            (not (start))
            (text_moved)
        )
    )
)
