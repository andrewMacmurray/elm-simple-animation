module Examples.Renderers exposing (examples)

import Element exposing (Element)
import Html exposing (Html)
import Html.Attributes
import Simple.Animated as Animated
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Svg exposing (Svg)
import Svg.Attributes
import Utils.Animated as Animated
import Utils.Stylesheet as Stylesheet
import Utils.UI exposing (group, groups)



-- Animation


flash : Animation
flash =
    Animation.fromTo
        { duration = 1000
        , options = [ Animation.loop ]
        }
        [ P.opacity 0 ]
        [ P.opacity 1 ]



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



-- Examples


examples : Element msg -> Element msg
examples =
    groups
        [ group "With HTML" (Element.html htmlExample)
        , group "With SVG" (Element.html svgExample)
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
