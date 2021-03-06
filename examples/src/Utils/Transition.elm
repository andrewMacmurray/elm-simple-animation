module Utils.Transition exposing (properties_)

import Element exposing (htmlAttribute)
import Simple.Transition as Transition


properties_ : List Transition.Property -> Element.Attribute msg
properties_ =
    htmlAttribute << Transition.properties
