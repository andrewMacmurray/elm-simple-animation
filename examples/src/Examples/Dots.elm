module Examples.Dots exposing (examples)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Utils.Animated as Animated
import Utils.UI exposing (..)


examples : Element msg -> Element msg
examples =
    groups [ single, delayed ]


single : Element msg
single =
    group "Dot" (single_ 0)


delayed : Element msg
delayed =
    group "Delayed Dots" delayed_


delayed_ : Element msg
delayed_ =
    row [ spacing medium ] (List.map (\i -> single_ (i * 125)) (List.range 0 5))


single_ : Animation.Millis -> Element msg
single_ delay =
    el [ inFront (Animated.el (expandFade delay) [] dot_) ] dot_


dot_ : Element msg
dot_ =
    el
        [ Background.color (rgb 0 0 0)
        , Border.rounded 1000
        , width (px medium)
        , height (px medium)
        ]
        none


expandFade : Animation.Millis -> Animation
expandFade delay =
    Animation.fromTo
        { duration = 2000
        , options = [ Animation.loop, Animation.delay delay ]
        }
        [ P.opacity 1, P.scale 1 ]
        [ P.opacity 0, P.scale 2 ]
