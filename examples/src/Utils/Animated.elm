module Utils.Animated exposing
    ( animatedElmCssDiv
    , circle
    , el
    , g
    , path
    , typedSvgG
    )

import Element exposing (Element)
import Html.Styled as Styled
import Html.Styled.Attributes
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



-- Elm CSS


animatedElmCssDiv : Animation -> List (Styled.Attribute msg) -> List (Styled.Html msg) -> Styled.Html msg
animatedElmCssDiv =
    animatedElmCssNode Styled.div


animatedElmCssNode :
    (List (Styled.Attribute msg) -> List (Styled.Html msg) -> Styled.Html msg)
    -> Animation
    -> List (Styled.Attribute msg)
    -> List (Styled.Html msg)
    -> Styled.Html msg
animatedElmCssNode =
    Animated.elmCss
        { text = Styled.text
        , node = Styled.node
        , class = Html.Styled.Attributes.class
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
