module Examples.Steps exposing (examples)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Internal.Property as P
import Simple.Animation as Animation exposing (Animation)
import Utils.Animated as Animated
import Utils.UI exposing (blue, gold, group, groups, large, medium)


examples : Element msg -> Element msg
examples =
    groups [ moveSquare ]


moveSquare =
    group "Steps with different eases" moveSquare_


moveSquare_ =
    row [ spacing large ]
        [ linearSquare
        , easeSquare
        , zippySquare
        ]


linearSquare =
    column [ spacing medium ]
        [ text "Linear"
        , Animated.el (moveAnim Animation.linear) [] square
        ]


zippySquare =
    column [ spacing medium ]
        [ text "Zippy"
        , Animated.el (moveAnim Animation.zippy) [] square
        ]


easeSquare =
    column [ spacing medium ]
        [ text "Ease In Out"
        , Animated.el (moveAnim Animation.easeInOut) [] square
        ]


moveAnim : Animation.Option -> Animation
moveAnim ease =
    Animation.steps
        { startAt = [ P.xy 0 0 ]
        , options = [ Animation.loop, ease ]
        }
        [ Animation.step 600 [ P.xy 50 0 ]
        , Animation.step 600 [ P.xy 50 50 ]
        , Animation.step 600 [ P.xy 0 50 ]
        , Animation.step 600 [ P.xy 0 0 ]
        ]


square =
    el
        [ width (px 30)
        , height (px 30)
        , Background.color gold
        , Border.rounded 3
        , Border.color blue
        , Border.width 3
        ]
        none
