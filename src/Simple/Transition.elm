module Simple.Transition exposing
    ( Millis
    , properties, all
    , Option, delay
    , linear, easeIn, easeOut, easeInOut, cubic
    , easeInSine, easeOutSine, easeInOutSine, easeInQuad, easeOutQuad, easeInOutQuad, easeInCubic, easeOutCubic, easeInOutCubic, easeInQuart, easeOutQuart, easeInOutQuart, easeInQuint, easeOutQuint, easeInOutQuint, easeInExpo, easeOutExpo, easeInOutExpo, easeInCirc, easeOutCirc, easeInOutCirc, easeInBack, easeOutBack, easeInOutBack
    , Property, backgroundColor, borderColor, color, opacity, transform, property
    )

{-| Build a Html Attribute for applying CSS transitions

@docs Millis


# Create a Transition

@docs properties, all


# Transition Options

Customise transition properties

@docs Option, delay


# Standard Eases

Standard CSS eases

@docs linear, easeIn, easeOut, easeInOut, cubic


# Extended Eases

See what these eases look and feel like: <https://easings.net>

@docs easeInSine, easeOutSine, easeInOutSine, easeInQuad, easeOutQuad, easeInOutQuad, easeInCubic, easeOutCubic, easeInOutCubic, easeInQuart, easeOutQuart, easeInOutQuart, easeInQuint, easeOutQuint, easeInOutQuint, easeInExpo, easeOutExpo, easeInOutExpo, easeInCirc, easeOutCirc, easeInOutCirc, easeInBack, easeOutBack, easeInOutBack


# Transition Properties

@docs Property, backgroundColor, borderColor, color, opacity, transform, property

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


{-| Time unit for all Transitions
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
    property "transform"


{-| -}
opacity : Millis -> List Option -> Property
opacity =
    property "opacity"


{-| -}
color : Millis -> List Option -> Property
color =
    property "color"


{-| -}
backgroundColor : Millis -> List Option -> Property
backgroundColor =
    property "background-color"


{-| -}
borderColor : Millis -> List Option -> Property
borderColor =
    property "border-color"


{-| Create a custom transition property (for any CSS attribute) - use with care as they may result in janky transitions!

e.g. for SVG fill:

    property "fill" 500 []

-}
property : String -> Millis -> List Option -> Property
property =
    Internal.Property


{-| Delay the start of the transition by a number of `milliseconds`
-}
delay : Millis -> Option
delay =
    Delay



-- Standard Eases


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



-- Extended Eases


{-| -}
easeInSine : Option
easeInSine =
    Ease Ease.easeInSine


{-| -}
easeOutSine : Option
easeOutSine =
    Ease Ease.easeOutSine


{-| -}
easeInOutSine : Option
easeInOutSine =
    Ease Ease.easeInOutSine


{-| -}
easeInQuad : Option
easeInQuad =
    Ease Ease.easeInQuad


{-| -}
easeOutQuad : Option
easeOutQuad =
    Ease Ease.easeOutQuad


{-| -}
easeInOutQuad : Option
easeInOutQuad =
    Ease Ease.easeInOutQuad


{-| -}
easeInCubic : Option
easeInCubic =
    Ease Ease.easeInCubic


{-| -}
easeOutCubic : Option
easeOutCubic =
    Ease Ease.easeOutCubic


{-| -}
easeInOutCubic : Option
easeInOutCubic =
    Ease Ease.easeInOutCubic


{-| -}
easeInQuart : Option
easeInQuart =
    Ease Ease.easeInQuart


{-| -}
easeOutQuart : Option
easeOutQuart =
    Ease Ease.easeOutQuart


{-| -}
easeInOutQuart : Option
easeInOutQuart =
    Ease Ease.easeInOutQuart


{-| -}
easeInQuint : Option
easeInQuint =
    Ease Ease.easeInQuint


{-| -}
easeOutQuint : Option
easeOutQuint =
    Ease Ease.easeOutQuint


{-| -}
easeInOutQuint : Option
easeInOutQuint =
    Ease Ease.easeInOutQuint


{-| -}
easeInExpo : Option
easeInExpo =
    Ease Ease.easeInExpo


{-| -}
easeOutExpo : Option
easeOutExpo =
    Ease Ease.easeOutExpo


{-| -}
easeInOutExpo : Option
easeInOutExpo =
    Ease Ease.easeInOutExpo


{-| -}
easeInCirc : Option
easeInCirc =
    Ease Ease.easeInCirc


{-| -}
easeOutCirc : Option
easeOutCirc =
    Ease Ease.easeOutCirc


{-| -}
easeInOutCirc : Option
easeInOutCirc =
    Ease Ease.easeInOutCirc


{-| -}
easeInBack : Option
easeInBack =
    Ease Ease.easeInBack


{-| -}
easeOutBack : Option
easeOutBack =
    Ease Ease.easeOutBack


{-| -}
easeInOutBack : Option
easeInOutBack =
    Ease Ease.easeInOutBack
