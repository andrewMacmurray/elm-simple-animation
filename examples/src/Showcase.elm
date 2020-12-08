module Showcase exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Html exposing (Html)
import Simple.Animation as Animation
import Simple.Animation.Property as P
import Utils.Animated as Animated


main : Html msg
main =
    layout [ width fill, padding medium ] examples


examples : Element msg
examples =
    column
        [ centerX
        , width (fill |> maximum 800)
        ]
        [ animatedDot ]


animatedDot : Element msg
animatedDot =
    column [ spacing small ]
        [ text "Dot"
        , dot
        ]


dot : Element msg
dot =
    el [ inFront (Animated.el expandFade [] dot_) ] dot_


dot_ : Element msg
dot_ =
    el
        [ Background.color (rgb 0 0 0)
        , Border.rounded 1000
        , width (px medium)
        , height (px medium)
        ]
        none


expandFade =
    Animation.fromTo
        { duration = 2000
        , options = [ Animation.loop ]
        }
        [ P.opacity 1, P.scale 1 ]
        [ P.opacity 0, P.scale 2 ]



-- Spacing


small =
    14


medium =
    24
