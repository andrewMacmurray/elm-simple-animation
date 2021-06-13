module Utils.Animated exposing
    ( animatedStyledNode
    , circle
    , el
    , g
    , path
    , typedSvgG
    )

import Element exposing (Element)
import Html.Styled as Htmls
import Html.Styled.Attributes as Attr
import Simple.Animation exposing (Animation)
import Simple.Animation.Animated as Animated
import Svg exposing (Svg)
import Svg.Attributes
import TypedSvg
import TypedSvg.Attributes
import TypedSvg.Core as TypedSvg



-- Elm UI


el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
el =
    animatedUi Element.el


animatedUi :
    (List (Element.Attribute msg) -> children -> Element msg)
    -> Animation
    -> List (Element.Attribute msg)
    -> children
    -> Element msg
animatedUi =
    Animated.ui
        { behindContent = Element.behindContent
        , htmlAttribute = Element.htmlAttribute
        , html = Element.html
        }



-- Svg


g : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
g =
    animatedSvg Svg.g


circle : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
circle =
    animatedSvg Svg.circle


path : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
path =
    animatedSvg Svg.path


animatedSvg :
    (List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg)
    -> Animation
    -> List (Svg.Attribute msg)
    -> List (Svg msg)
    -> Svg msg
animatedSvg =
    Animated.svg
        { class = Svg.Attributes.class
        }



-- Typed Svg


typedSvgG : Animation -> List (TypedSvg.Attribute msg) -> List (TypedSvg.Svg msg) -> TypedSvg.Svg msg
typedSvgG =
    animatedTypedSvg TypedSvg.g


animatedTypedSvg :
    (List (TypedSvg.Attribute msg) -> List (TypedSvg.Svg msg) -> TypedSvg.Svg msg)
    -> Animation
    -> List (TypedSvg.Attribute msg)
    -> List (TypedSvg.Svg msg)
    -> TypedSvg.Svg msg
animatedTypedSvg node animation attributes children =
    Animated.custom
        (\className stylesheet ->
            node
                (TypedSvg.Attributes.class [ className ] :: attributes)
                (TypedSvg.style [] [ TypedSvg.text stylesheet ] :: children)
        )
        animation



-- elm-css


animatedStyledNode :
    (List (Htmls.Attribute msg) -> List (Htmls.Html msg) -> Htmls.Html msg)
    -> Animation
    -> List (Htmls.Attribute msg)
    -> List (Htmls.Html msg)
    -> Htmls.Html msg
animatedStyledNode nodeToAnimate animation attributes children =
    Animated.custom
        (\className stylesheet ->
            nodeToAnimate
                (Attr.class className :: attributes)
                (Htmls.node
                    "style"
                    []
                    [ Htmls.text stylesheet ]
                    :: children
                )
        )
        animation
