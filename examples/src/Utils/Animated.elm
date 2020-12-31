module Utils.Animated exposing
    ( el
    , g
    , path
    , typedSvgG
    )

import Element exposing (Element)
import Simple.Animated as Animated
import Simple.Animation exposing (Animation)
import Svg exposing (Svg)
import Svg.Attributes
import TypedSvg
import TypedSvg.Attributes
import TypedSvg.Core as TypedSvg



-- Elm UI


el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
el =
    ui Element.el


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


path : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
path =
    svg_ Svg.path


svg_ :
    (List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg)
    -> Animation
    -> List (Svg.Attribute msg)
    -> List (Svg msg)
    -> Svg msg
svg_ =
    Animated.node Svg.Attributes.class



-- Typed Svg


typedSvgG : Animation -> List (TypedSvg.Attribute msg) -> List (TypedSvg.Svg msg) -> TypedSvg.Svg msg
typedSvgG =
    typedSvg_ TypedSvg.g


typedSvg_ :
    (List (TypedSvg.Attribute msg) -> List (TypedSvg.Svg msg) -> TypedSvg.Svg msg)
    -> Animation
    -> List (TypedSvg.Attribute msg)
    -> List (TypedSvg.Svg msg)
    -> TypedSvg.Svg msg
typedSvg_ node anim attrs children =
    Animated.custom
        (\className stylesheet ->
            node
                (TypedSvg.Attributes.class [ className ] :: attrs)
                (TypedSvg.style [] [ TypedSvg.text stylesheet ] :: children)
        )
        anim
