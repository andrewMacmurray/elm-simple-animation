module Utils.Animated exposing
    ( column
    , el
    , g
    , row
    , svg
    )

import Element exposing (Element)
import Simple.Animated as Animated
import Simple.Animation exposing (Animation)
import Svg exposing (Svg)
import Svg.Attributes



-- Elm UI


el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
el =
    ui Element.el


column : Animation -> List (Element.Attribute msg) -> List (Element msg) -> Element msg
column =
    ui Element.column


row : Animation -> List (Element.Attribute msg) -> List (Element msg) -> Element msg
row =
    ui Element.row


ui :
    (List (Element.Attribute msg) -> children -> Element msg)
    -> Animation
    -> List (Element.Attribute msg)
    -> children
    -> Element msg
ui =
    Animated.ui
        { behindContent = Element.behindContent
        , htmlAttribute = Element.htmlAttribute
        , html = Element.html
        }



-- Svg


g : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
g =
    svg_ Svg.g


svg : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
svg =
    svg_ Svg.svg


svg_ :
    (List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg)
    -> Animation
    -> List (Svg.Attribute msg)
    -> List (Svg msg)
    -> Svg msg
svg_ =
    Animated.node Svg.Attributes.class
