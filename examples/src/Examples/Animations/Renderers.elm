module Examples.Animations.Renderers exposing (examples)

import Element exposing (Element)
import Html exposing (Html)
import Html.Attributes
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Animated as Animated
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
        { startAt = [ P.opacity 0, P.backgroundColor "#0382c8" ]
        , options = [ Animation.loop ]
        }
        [ Animation.step 1000 [ P.opacity 1, P.backgroundColor "rgb(19 228 187)" ]
        , Animation.step 1000 [ P.opacity 0, P.backgroundColor "#0382c8" ]
        ]



-- Html


htmlExample : Html msg
htmlExample =
    Animated.div flash
        [ Html.Attributes.class "text" ]
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
        [ group "With HTML" (html htmlExample)
        , group "With SVG" (html svgExample)
        , group "With Typed SVG" (html typedSvgExample)
        ]



-- Utils


stylesheet : Html msg
stylesheet =
    Stylesheet.stylesheet
        """
        .text {
            color: white;
            border-radius: 10px;
            text-align: center;
            margin: 12px 0;
            padding: 24px;
        }

        .blue-fill {
            fill: blue;
        }
        """


html : Html msg -> Element msg
html =
    Element.html >> Element.el [ Element.width (Element.fill |> Element.maximum 200) ]
