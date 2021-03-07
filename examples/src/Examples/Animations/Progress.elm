module Examples.Animations.Progress exposing (examples)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Utils.Animated as Animated
import Utils.UI exposing (blue, group, groups, small)



-- Animation


animateProgress : Float -> Animation
animateProgress percent_ =
    Animation.fromTo
        { duration = 2000
        , options = []
        }
        [ P.property "clip-path" (insetPercent 0) ]
        [ P.property "clip-path" (insetPercent percent_) ]


insetPercent : Float -> String
insetPercent n =
    "inset(0 " ++ pc (100 - n) ++ " 0 0)"


pc : Float -> String
pc n =
    String.fromFloat n ++ "%"



-- Progress Bar


progressBar : Float -> Element msg
progressBar percent =
    el
        [ width (fill |> maximum 300)
        , height (px 22)
        , Border.width 2
        , Border.rounded 20
        ]
        (Animated.el (animateProgress percent)
            [ width fill
            , height fill
            , Background.color blue
            , Border.rounded 20
            ]
            none
        )



-- Examples


examples : Element msg -> Element msg
examples =
    groups
        [ group "clip-path Progress Bars" progressBars
        ]


progressBars : Element msg
progressBars =
    column [ spacing small, width fill ]
        [ progressBar 100
        , progressBar 50
        , progressBar 30
        ]
