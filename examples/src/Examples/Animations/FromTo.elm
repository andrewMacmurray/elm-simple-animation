module Examples.Animations.FromTo exposing (examples)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Utils.Animated as Animated
import Utils.UI exposing (..)



-- Animation


expandFade : Animation.Millis -> Animation
expandFade delay =
    Animation.fromTo
        { duration = 2000
        , options = [ Animation.loop, Animation.delay delay ]
        }
        [ P.opacity 1, P.scale 1 ]
        [ P.opacity 0, P.scale 2 ]



-- Dot


dot : Animation.Millis -> Element msg
dot delay =
    el [ inFront (Animated.el (expandFade delay) [] dot_) ] dot_



-- Delayed Dots


delayedDots : Element msg
delayedDots =
    row [ spacing medium ] (List.map (\i -> dot (i * 125)) (List.range 0 5))



-- Examples


examples : Element msg -> Element msg
examples =
    groups
        [ group "Dot" (dot 0)
        , group "Delayed Dots" delayedDots
        ]



-- Helpers


dot_ : Element msg
dot_ =
    el
        [ Background.color (rgb 0 0 0)
        , Border.rounded 1000
        , width (px medium)
        , height (px medium)
        ]
        none
