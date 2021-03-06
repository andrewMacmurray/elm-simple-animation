module Utils.Transition exposing
    ( all_
    , properties_
    )

import Element exposing (htmlAttribute)
import Simple.Transition as Transition


properties_ : List Transition.Property -> Element.Attribute msg
properties_ =
    htmlAttribute << Transition.properties


all_ :
    { duration : Transition.Millis, options : List Transition.Option }
    -> List (Transition.Millis -> List Transition.Option -> Transition.Property)
    -> Element.Attribute msg
all_ options =
    htmlAttribute << Transition.all options
