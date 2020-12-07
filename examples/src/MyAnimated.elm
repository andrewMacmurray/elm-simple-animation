module MyAnimated exposing
    ( column
    , el
    , g
    , row
    , svg
    )

import Animated
import Element exposing (Element, behindContent, htmlAttribute)
import Html.Attributes
import Simple.Animation exposing (Animation)
import Svg exposing (Svg)
import Svg.Attributes



-- Elm UI


el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
el =
    elmUINode Element.el


column : Animation -> List (Element.Attribute msg) -> List (Element msg) -> Element msg
column =
    elmUINode Element.column


row : Animation -> List (Element.Attribute msg) -> List (Element msg) -> Element msg
row =
    elmUINode Element.row


elmUINode :
    (List (Element.Attribute msg) -> children -> Element msg)
    -> Animation
    -> List (Element.Attribute msg)
    -> children
    -> Element msg
elmUINode node_ anim attributes children =
    Animated.custom
        (\class stylesheet ->
            node_
                (List.append
                    [ htmlAttribute (Html.Attributes.class class)
                    , behindContent (Element.html stylesheet)
                    ]
                    attributes
                )
                children
        )
        anim



-- Svg


g : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
g =
    svgNode Svg.g


svg : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
svg =
    svgNode Svg.svg


svgNode :
    (List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg)
    -> Animation
    -> List (Svg.Attribute msg)
    -> List (Svg msg)
    -> Svg msg
svgNode node_ anim attrs children =
    Animated.custom (\class stylesheet -> node_ (Svg.Attributes.class class :: attrs) (stylesheet :: children)) anim
