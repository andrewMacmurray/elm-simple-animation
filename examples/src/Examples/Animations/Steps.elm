module Examples.Animations.Steps exposing (examples)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Utils.Animated as Animated
import Utils.UI exposing (blue, gold, groups, large, medium)



-- Steps Animation


stepsAnimation : Animation.Option -> Animation
stepsAnimation ease =
    Animation.steps
        { startAt = [ P.xy 0 0, P.rotate 0 ]
        , options = [ Animation.loop, ease ]
        }
        [ Animation.step 600 [ P.xy 50 0, P.rotate 45 ]
        , Animation.step 600 [ P.xy 50 50, P.scale 2 ]
        , Animation.step 600 [ P.xy 0 50, P.rotate 0 ]
        , Animation.step 600 [ P.xy 0 0 ]
        ]



-- Examples


examples : Element msg -> Element msg
examples =
    groups [ squaresWithEases ]


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
        , Animated.el (stepsAnimation ease) [] square
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
