module Examples.Steps exposing (examples)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Internal.Property as P
import Simple.Animation as Animation exposing (Animation)
import Utils.Animated as Animated
import Utils.UI exposing (blue, gold, group, groups, large, medium)



-- Steps Animation


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



-- Examples


examples : Element msg -> Element msg
examples =
    groups [ stepsWithEases ]


stepsWithEases : Element msg
stepsWithEases =
    group "Steps with different eases" squaresWithEases


squaresWithEases : Element msg
squaresWithEases =
    wrappedRow [ spacing large ]
        [ squareExamples
            [ ( Animation.linear, "Linear" )
            , ( Animation.easeIn, "Ease In" )
            , ( Animation.easeOut, "Ease Out" )
            , ( Animation.easeInOut, "Ease In Out" )
            ]
        , squareExamples
            [ ( Animation.easeInSine, "Ease In Sine" )
            , ( Animation.easeOutSine, "Ease Out Sine" )
            , ( Animation.easeInOutSine, "Ease In Out Sine" )
            ]
        , squareExamples
            [ ( Animation.easeInQuad, "Ease In Quad" )
            , ( Animation.easeOutQuad, "Ease Out Quad" )
            , ( Animation.easeInOutQuad, "Ease In Out Quad" )
            ]
        ]


squareExamples : List ( Animation.Option, String ) -> Element msg
squareExamples eases_ =
    row [ spacing large ] (List.map squareExample eases_)


squareExample : ( Animation.Option, String ) -> Element msg
squareExample ( ease, name ) =
    column [ spacing medium, paddingXY 0 medium ]
        [ text name
        , Animated.el (moveAnim ease) [] square
        ]


square : Element msg
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
