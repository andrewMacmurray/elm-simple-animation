module Examples.Animations.Directions exposing (examples)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Utils.Animated as Animated
import Utils.UI exposing (blue, group, groups, large)



-- Directions


fall : List Animation.Option -> Animation
fall options =
    Animation.fromTo
        { duration = 1500
        , options = Animation.loop :: options
        }
        [ P.y 0 ]
        [ P.y 50 ]


regularDirection : Element msg
regularDirection =
    Animated.el (fall []) [] circle


reversedDirection : Element msg
reversedDirection =
    Animated.el (fall [ Animation.reverse ]) [] circle


alternatingDirection : Element msg
alternatingDirection =
    Animated.el (fall [ Animation.yoyo ]) [] circle


examples : Element msg -> Element msg
examples =
    groups
        [ row [ spacing large ]
            [ group "Regular Direction" regularDirection
            , group "Reversed Direction" reversedDirection
            , group "Alternating Direction" alternatingDirection
            ]
        ]


circle : Element msg
circle =
    el
        [ Background.color blue
        , Border.rounded 50
        , width (px 50)
        , height (px 50)
        ]
        none
