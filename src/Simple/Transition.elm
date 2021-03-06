module Simple.Transition exposing
    ( Millis
    , properties, all
    , Option, delay
    , linear, easeIn, easeOut, easeInOut, cubic
    , Property, backgroundColor, borderColor, color, opacity, transform
    )

{-| Build a Html Attribute for applying CSS transitions

@docs Millis


# Create a Transition

@docs properties, all


# Transition Options

Customise transition properties

@docs Option, delay


# CSS Eases

@docs linear, easeIn, easeOut, easeInOut, cubic


# Transition Properties

@docs Property, backgroundColor, borderColor, color, opacity, transform

-}

import Html
import Internal.Ease as Ease
import Internal.Transition as Internal exposing (Option(..))
import Internal.Unit as Unit


type alias Transition =
    Internal.Transition


{-| -}
type alias Property =
    Internal.Property


{-| -}
type alias Option =
    Internal.Option


{-| Unit for all Transitions
-}
type alias Millis =
    Unit.Millis


{-| Create a transition with the same duration, ease and delay for all properties

    Transition.all
        { duration = 500
        , options = [ Transition.delay 200, Transition.linear ]
        }
        [ Transition.opacity
        , Transition.color
        ]

Will render a CSS transition: `opacity 500ms linear 200ms, color 500ms linear 200ms`

-}
all : { duration : Millis, options : List Option } -> List (Millis -> List Option -> Property) -> Html.Attribute msg
all config =
    Internal.all config >> Internal.toAttr


{-| Create a transition for a list of properties

    Transition.properties
        [ Transition.opacity 200 [ Transition.delay 100 ]
        , Transition.color 500 [ Transition.easeInOut ]
        ]

Will render a CSS transition: `opacity 200ms ease 100ms, color 500ms ease-in-out 0ms`

-}
properties : List Property -> Html.Attribute msg
properties =
    Internal.properties >> Internal.toAttr


{-| -}
transform : Millis -> List Option -> Property
transform =
    Internal.Property "transform"


{-| -}
opacity : Millis -> List Option -> Property
opacity =
    Internal.Property "opacity"


{-| -}
color : Millis -> List Option -> Property
color =
    Internal.Property "color"


{-| -}
backgroundColor : Millis -> List Option -> Property
backgroundColor =
    Internal.Property "background-color"


{-| -}
borderColor : Millis -> List Option -> Property
borderColor =
    Internal.Property "border-color"


{-| Delay the start of the transition by a number of `milliseconds`
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
