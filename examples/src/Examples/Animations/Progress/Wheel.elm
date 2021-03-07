module Examples.Animations.Progress.Wheel exposing (progress)

import Element exposing (Element)
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Svg exposing (Svg)
import Svg.Attributes exposing (..)
import Utils.Animated as Animated



-- Animation


animateProgressLine : Int -> Animation
animateProgressLine percent =
    Animation.fromTo
        { duration = 3000
        , options = []
        }
        [ P.property "stroke-dashoffset" (offset 0) ]
        [ P.property "stroke-dashoffset" (offset percent) ]


offset : Int -> String
offset percent =
    String.fromFloat (circumference * (1 - toFloat percent / 100))



-- Progress Wheel


progress : Int -> Element msg
progress percent =
    Element.el [ Element.width (Element.px 100) ]
        (Element.html
            (Svg.svg [ width "100%", viewBox_ ]
                [ progressCircle percent
                ]
            )
        )


progressCircle : Int -> Svg msg
progressCircle percent =
    Svg.g
        [ transform "rotate(90)"
        , style originCenter
        ]
        [ Svg.circle
            [ stroke "#e6e6e6"
            , fill "none"
            , cx "60"
            , cy "60"
            , r (String.fromFloat radius)
            , strokeWidth_
            ]
            []
        , Animated.circle (animateProgressLine percent)
            [ fill "none"
            , stroke "blue"
            , strokeLinecap "round"
            , strokeDasharray (String.fromFloat circumference)
            , cx "60"
            , cy "60"
            , r (String.fromFloat radius)
            , strokeWidth_
            ]
            []
        ]



-- Helpers


strokeWidth_ : Svg.Attribute msg
strokeWidth_ =
    strokeWidth (String.fromInt 6)


viewBox_ : Svg.Attribute msg
viewBox_ =
    viewBox
        (join
            [ "0 0 "
            , String.fromFloat viewboxWidth
            , String.fromFloat viewboxHeight
            ]
        )


originCenter : String
originCenter =
    join
        [ "transform-origin:"
        , px (viewboxHeight / 2)
        , px (viewboxWidth / 2)
        ]


px : Float -> String
px n =
    String.fromFloat n ++ "px"


join : List String -> String
join =
    String.join " "



-- Config


radius : Float
radius =
    54


circumference : Float
circumference =
    2 * pi * radius


viewboxHeight : Float
viewboxHeight =
    120


viewboxWidth : Float
viewboxWidth =
    120
