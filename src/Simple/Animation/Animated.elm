module Simple.Animation.Animated exposing
    ( div, html
    , SvgOptions, svg
    , UiOptions, ui
    , ClassName, Stylesheet, custom
    )

{-|


# Render animations on the page

This module gives you animated `Html` `div`s out of the box, and some helpers to create animated versions of whatever `UI` library you're using.


## Common Helpers

You can find examples of building many of the common helpers mentioned below: <https://github.com/andrewMacmurray/elm-simple-animation/blob/main/examples/src/Utils/Animated.elm>


# Html Animations

@docs div, html


# Hook Into SVG

@docs SvgOptions, svg


# Hook Into Elm UI

@docs UiOptions, ui


# Custom Renderer

@docs ClassName, Stylesheet, custom

-}

import Html exposing (Html)
import Html.Attributes
import Internal.Animation as Animation exposing (Animation)



-- Html


{-|


### Render an Animated `div`

    import Html exposing (Html)
    import Simple.Animation as Animation exposing (Animation)
    import Simple.Animation.Animated as Animated
    import Simple.Animation.Property as P

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

For example, `Simple.Animation.Animated.div` is defined like this:

    div : Animation -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
    div =
        Simple.Animation.Animated.html Html.div

-}
html :
    (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> Animation
    -> List (Html.Attribute msg)
    -> List (Html msg)
    -> Html msg
html =
    node { class = Html.Attributes.class }


{-| -}
type alias SvgOptions msg =
    { class : String -> Html.Attribute msg
    }


{-| So you can use whatever version of `elm/svg` you like use the `Simple.Animation.Animated.svg` function along with `Svg.Attributes.class` to create animated `Svg` elements:

    animatedSvg =
        Simple.Animation.Animated.svg
            { class = Svg.Attributes.class
            }

Then render an animation

    dot : Svg msg
    dot =
        Svg.svg []
            [ g expandFade [] [ svgDot ]
            ]

    g : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
    g =
        animatedSvg Svg.g

-}
svg :
    SvgOptions msg
    -> (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> Animation
    -> List (Html.Attribute msg)
    -> List (Html msg)
    -> Html msg
svg =
    node


node :
    SvgOptions msg
    -> (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> Animation
    -> List (Html.Attribute msg)
    -> List (Html msg)
    -> Html msg
node options node_ anim attrs els =
    node_
        (options.class (Animation.name_ anim) :: attrs)
        (toStylesheet_ anim :: els)


{-| -}
type alias UiOptions element attribute msg =
    { behindContent : element -> attribute
    , html : Html msg -> element
    , htmlAttribute : Html.Attribute msg -> attribute
    }


{-| Create animated `elm-ui` `Element`s

    animatedUi =
        Simple.Animation.Animated.ui
            { behindContent = Element.behindContent
            , htmlAttribute = Element.htmlAttribute
            , html = Element.html
            }

Then render an animation

    dot : Element msg
    dot =
        el expandFade [] elmUiDot

    el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
    el =
        animatedUi Element.el

-}
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


{-| When you want to completely customise how to render animations you can use the low level `Simple.Animation.Animated.custom`. This gives you access to the raw animation `stylesheet` and `class` name that will apply the animation.

For example, say you wanted to animate `elm-community/typed-svg` nodes - you could create animated versions like this:

    g : Animation -> List (TypedSvg.Attribute msg) -> List (TypedSvg.Svg msg) -> TypedSvg.Svg msg
    g =
        animatedTypedSvg TypedSvg.g

    animatedTypedSvg node animation attributes children =
        Simple.Animation.Animated.custom
            (\className stylesheet ->
                node
                    (TypedSvg.Attributes.class [ className ] :: attributes)
                    (TypedSvg.style [] [ TypedSvg.text stylesheet ] :: children)
            )
            animation

-}
custom : (ClassName -> Stylesheet -> animated) -> Animation -> animated
custom toAnimated anim =
    toAnimated
        (Animation.name_ anim)
        (Animation.stylesheet_ anim)


toStylesheet_ : Animation -> Html msg
toStylesheet_ anim =
    Html.node "style" [] [ Html.text (Animation.stylesheet_ anim) ]
