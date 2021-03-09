module Examples.Animations.Progress exposing (examples)

import Element exposing (..)
import Examples.Animations.Progress.Bar as Bar
import Examples.Animations.Progress.Wheel as Wheel
import Utils.UI exposing (group, groups, small)



-- Examples


examples : Element msg -> Element msg
examples =
    groups
        [ group "clip-path Progress Bars" progressBars
        , group "progress wheel" progressWheels
        ]


progressBars : Element msg
progressBars =
    column [ spacing small, width fill ]
        [ Bar.progress 100
        , Bar.progress 50
        , Bar.progress 30
        ]


progressWheels : Element msg
progressWheels =
    row [ spacing small, width fill ]
        [ Wheel.progress 100
        , Wheel.progress 75
        , Wheel.progress 50
        ]
