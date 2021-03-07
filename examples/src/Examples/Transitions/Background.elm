module Examples.Transitions.Background exposing (examples)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Simple.Transition as Transition
import Utils.Transition as Transition
import Utils.UI exposing (black, blue, gold, groups, white)


examples : Element msg -> Element msg
examples =
    groups [ glowingBox ]


glowingBox : Element msg
glowingBox =
    el
        [ width fill
        , height (px 250)
        , pointer
        , mouseOver [ Background.color gold, Font.color black ]
        , Background.color blue
        , Font.color white
        , Transition.properties_
            [ Transition.backgroundColor 500 []
            , Transition.color 500 [ Transition.delay 100 ]
            ]
        ]
        (el
            [ centerX
            , centerY
            ]
            (text "Hover over me")
        )
