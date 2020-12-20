module Simple.Animated exposing
    ( div, html
    , node
    , UiOptions, ui
    , ClassName, Stylesheet, custom
    )

{-|


# Render Html Animations

@docs div, html


# Hook Into SVG

@docs node


# Hook Into Elm UI

@docs UiOptions, ui


# Custom Renderer

@docs ClassName, Stylesheet, custom

-}

import Html exposing (Html)
import Html.Attributes
import Internal.Animation as Animation exposing (Animation)



-- Html


{-| -}
div : Animation -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
div =
    html Html.div


{-| -}
html :
    (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> Animation
    -> List (Html.Attribute msg)
    -> List (Html msg)
    -> Html msg
html =
    node Html.Attributes.class


{-| -}
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
        (stylesheet_ anim :: els)


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
            [ options.behindContent (options.html (stylesheet_ anim))
            , options.htmlAttribute (Html.Attributes.class (Animation.name_ anim))
            ]
            attrs
        )
        els


{-| -}
type alias ClassName =
    String


{-| -}
type alias Stylesheet msg =
    Html msg


{-| -}
custom : (ClassName -> Stylesheet msg -> animated) -> Animation -> animated
custom toAnimated anim =
    toAnimated
        (Animation.name_ anim)
        (stylesheet_ anim)


stylesheet_ : Animation -> Stylesheet msg
stylesheet_ anim =
    Html.node "style" [] [ Html.text (Animation.stylesheet_ anim) ]
