module Simple.Transition exposing
    ( Transition, all, properties
    , Option, delay
    , Property, backgroundColor, borderColor, color, opacity, transform
    , linear, easeIn, easeOut, easeInOut, cubic
    )

{-| Build a CSS transition

All transition durations are in `milliseconds`


# Create an Transition

@docs Transition, all, properties


# Options

Set the options accepted by the transition property

@docs Option, delay


# Properties

@docs Property, backgroundColor, borderColor, color, opacity, transform


# Standard Eases

Standard CSS eases

@docs linear, easeIn, easeOut, easeInOut, cubic

-}

import Html
import Internal.Animation exposing (Millis)
import Internal.Ease as Ease
import Internal.Transition as Internal exposing (..)


{-| -}
type alias Transition =
    Internal.Transition


{-| -}
type alias Property =
    Internal.Property


{-| -}
type alias Option =
    Internal.Option


{-| Create a transition where the same duration, ease and delay are applied to all the supplied properties

    Transition.all
        { duration = 500
        , options = [ Transition.delay 200, Transition.linear ]
        }
        [ Transition.opacity
        ]

     Which will render the transition:

     "opacity 500ms linear 200ms, color 500ms linear 200ms"

-}
all : Config -> List PropertyShorthand -> Html.Attribute msg
all config props =
    Internal.all config props
        |> Internal.toAttr


{-| Create a transition supplying separate options for each property

    Transition.properties
        [ Transition.opacity 200 [ Transition.delay 100 ]
        , Transition.color 500 [ Transition.easeInOut ]
        ]

     Which will render the transition:

     "opacity 200ms ease 100ms, color 500ms ease-in-out 0ms"

-}
properties : List Property -> Html.Attribute msg
properties =
    Internal.properties
        >> Internal.toAttr


{-| Add a transition to the transform property
-}
transform : PropertyShorthand
transform =
    Internal.Property "transform"


{-| Add a transition to the opacity property
-}
opacity : PropertyShorthand
opacity =
    Internal.Property "opacity"


{-| Add a transition to the color property
-}
color : PropertyShorthand
color =
    Internal.Property "color"


{-| Add a transition to the background-color property
-}
backgroundColor : PropertyShorthand
backgroundColor =
    Internal.Property "background-color"


{-| Add a transition to the border-color property
-}
borderColor : PropertyShorthand
borderColor =
    Internal.Property "border-color"


{-| Set the animation delay
-}
delay : Millis -> Option
delay =
    Delay


{-| -}
linear : Option
linear =
    Ease Ease.Linear


{-| -}
easeIn : Option
easeIn =
    Ease Ease.EaseIn


{-| -}
easeOut : Option
easeOut =
    Ease Ease.EaseOut


{-| -}
easeInOut : Option
easeInOut =
    Ease Ease.EaseInOut


{-| -}
cubic : Float -> Float -> Float -> Float -> Option
cubic a b c d =
    Ease (Ease.Cubic a b c d)
