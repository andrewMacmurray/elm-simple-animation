module Examples.Renderers exposing (examples)

import Element exposing (Element)
import Html exposing (Html)
import Html.Attributes
import Simple.Animated as Animated
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
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



-- Examples


examples : Element msg -> Element msg
examples =
    groups
        [ group "With Html" (Element.html htmlExample)
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
        """
