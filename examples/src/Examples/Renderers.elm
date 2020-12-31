module Examples.Renderers exposing (examples)

import Element exposing (Element)
import Html exposing (Html)
import Html.Attributes
import Simple.Animated as Animated
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Svg exposing (Svg)
import Svg.Attributes
import TypedSvg
import TypedSvg.Attributes
import TypedSvg.Core as TypedSvg
import TypedSvg.Types exposing (num)
import Utils.Animated as Animated
import Utils.Stylesheet as Stylesheet
import Utils.UI exposing (group, groups)



-- Animation


flash : Animation
flash =
    Animation.steps
        { startAt = [ P.opacity 0 ]
        , options = [ Animation.loop ]
        }
        [ Animation.step 1000 [ P.opacity 1 ]
        , Animation.step 1000 [ P.opacity 0 ]
        ]



-- Html


htmlExample : Html msg
htmlExample =
    Animated.div flash
        [ Html.Attributes.class "blue-text" ]
        [ Html.text "I'm animating!"
        , stylesheet
        ]



-- Svg


svgExample : Svg msg
svgExample =
    Svg.svg [ Svg.Attributes.viewBox "0 0 20 20" ]
        [ Animated.g flash
            [ Svg.Attributes.class "blue-fill" ]
            [ rectangle
            , circle
            ]
        ]


rectangle : Svg msg
rectangle =
    Svg.rect
        [ Svg.Attributes.x "2"
        , Svg.Attributes.y "10"
        , Svg.Attributes.width "10"
        , Svg.Attributes.height "5"
        ]
        []


circle : Svg msg
circle =
    Svg.circle
        [ Svg.Attributes.cx "5"
        , Svg.Attributes.cy "5"
        , Svg.Attributes.r "2"
        ]
        []



-- Typed SVG


typedSvgExample : Html msg
typedSvgExample =
    TypedSvg.svg
        [ TypedSvg.Attributes.viewBox 0 0 20 20
        ]
        [ Animated.typedSvgG flash
            [ TypedSvg.Attributes.class [ "blue-fill" ] ]
            [ typedCircle
            , typedRectangle
            ]
        ]


typedRectangle : TypedSvg.Svg msg
typedRectangle =
    TypedSvg.rect
        [ TypedSvg.Attributes.x (num 2)
        , TypedSvg.Attributes.y (num 10)
        , TypedSvg.Attributes.width (num 10)
        , TypedSvg.Attributes.height (num 5)
        ]
        []


typedCircle : TypedSvg.Svg msg
typedCircle =
    TypedSvg.circle
        [ TypedSvg.Attributes.cx (num 5)
        , TypedSvg.Attributes.cy (num 5)
        , TypedSvg.Attributes.r (num 2)
        ]
        []



-- Examples


examples : Element msg -> Element msg
examples =
    groups
        [ group "With HTML" (Element.html htmlExample)
        , group "With SVG" (Element.html svgExample)
        , group "With Typed SVG" (Element.html typedSvgExample)
        ]



-- Utils


stylesheet : Html msg
stylesheet =
    Stylesheet.stylesheet
        """
        .blue-text {
            color: blue;
            padding: 24px 0px;
        }

        .blue-fill {
            fill: blue;
        }
        """
