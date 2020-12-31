module Simple.Animated exposing
    ( div, html
    , svg
    , UiOptions, ui
    , ClassName, Stylesheet, custom
    )

{-|


# Render animations on the page

This module gives you animated `Html` `div`s out of the box, and some helpers to create animated versions of whatever `UI` library you're using.

e.g. You want animated `elm-ui` `Element`s? Create an animated helper like this:

    animatedUi =
        Simple.Animated.ui
            { behindContent = Element.behindContent
            , htmlAttribute = Element.htmlAttribute
            , html = Element.html
            }

Then make animated `el`s, `column`s and `row`s!

    el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
    el =
        animatedUi Element.el

Then render an animation

    dot : Element msg
    dot =
        Utils.Animated.el expandFade [] elmUiDot


## Common Helpers

You can find many of these common helpers here: <https://github.com/andrewMacmurray/elm-simple-animation/blob/main/examples/src/Utils/Animated.elm>


# Html Animations

@docs div, html


# Hook Into SVG

So you can use whatever version of `elm/svg` you like use the `Simple.Animated.svg` function along with `Svg.Attributes.class` to create animated `Svg` elements:

    g : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
    g =
        animatedSvg Svg.g

    animatedSvg =
        Simple.Animated.node Svg.Attributes.class

Then render an animation

    dot : Svg msg
    dot =
        Svg.svg []
            [ Utils.Animated.g expandFade [] [ svgDot ]
            ]

@docs svg


# Hook Into Elm UI

Create animated `elm-ui` `Element`s

    el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
    el =
        animatedUi Element.el

    animatedUi =
        Simple.Animated.ui
            { behindContent = Element.behindContent
            , htmlAttribute = Element.htmlAttribute
            , html = Element.html
            }

Then render an animation

    dot : Element msg
    dot =
        Utils.Animated.el expandFade [] elmUiDot

@docs UiOptions, ui


# Custom Renderer

When you want to completely customise how to render animations you can use the low level `Simple.Animated.custom` - which gives you access to the raw animation `stylesheet` and `class` name that will apply the animation.

For example, say you wanted to animate `elm-community/typed-svg` nodes - you could create animated versions like this:

    g : Animation -> List (TypedSvg.Attribute msg) -> List (TypedSvg.Svg msg) -> TypedSvg.Svg msg
    g =
        animatedTypedSvg TypedSvg.g

    animatedTypedSvg node animation attributes children =
        Simple.Animated.custom
            (\className stylesheet ->
                node
                    (TypedSvg.Attributes.class [ className ] :: attributes)
                    (TypedSvg.style [] [ TypedSvg.text stylesheet ] :: children)
            )
            animation

@docs ClassName, Stylesheet, custom

-}

import Html exposing (Html)
import Html.Attributes
import Internal.Animation as Animation exposing (Animation)



-- Html


{-|


### Render an Animated `div`

    dot : Html msg
    dot =
        Animated.div expandFade [ class "dot" ] []

    expandFade : Animation
    expandFade =
        Animation.fromTo
            { duration = 2000
            , options = [ Animation.loop ]
            }
            [ P.opacity 1, P.scale 1 ]
            [ P.opacity 0, P.scale 2 ]

-}
div : Animation -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
div =
    html Html.div


{-|


### Create any animated `Html` node:

For example, `Simple.Animated.div` is defined like this:

    div : Animation -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
    div =
        Simple.Animated.html Html.div

-}
html :
    (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> Animation
    -> List (Html.Attribute msg)
    -> List (Html msg)
    -> Html msg
html =
    node Html.Attributes.class


{-| -}
svg :
    (ClassName -> Html.Attribute msg)
    -> (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> Animation
    -> List (Html.Attribute msg)
    -> List (Html msg)
    -> Html msg
svg =
    node


node :
    (ClassName -> Html.Attribute msg)
    -> (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> Animation
    -> List (Html.Attribute msg)
    -> List (Html msg)
    -> Html msg
node toClass_ node_ anim attrs els =
    node_
        (toClass_ (Animation.name_ anim) :: attrs)
        (toStylesheet_ anim :: els)


{-| -}
type alias UiOptions element attribute msg =
    { behindContent : element -> attribute
    , html : Html msg -> element
    , htmlAttribute : Html.Attribute msg -> attribute
    }


{-| -}
ui :
    UiOptions element attribute msg
    -> (List attribute -> children -> element)
    -> Animation
    -> List attribute
    -> children
    -> element
ui options node_ anim attrs els =
    node_
        (List.append
            [ options.behindContent (options.html (toStylesheet_ anim))
            , options.htmlAttribute (Html.Attributes.class (Animation.name_ anim))
            ]
            attrs
        )
        els


{-| -}
type alias ClassName =
    String


{-| -}
type alias Stylesheet =
    String


{-| -}
custom : (ClassName -> Stylesheet -> animated) -> Animation -> animated
custom toAnimated anim =
    toAnimated
        (Animation.name_ anim)
        (Animation.stylesheet_ anim)


toStylesheet_ : Animation -> Html msg
toStylesheet_ anim =
    Html.node "style" [] [ Html.text (Animation.stylesheet_ anim) ]
