module Internal.Transition exposing (Property(..), Transition(..), toAttr)

import Html.Attributes
import Internal.Animation exposing (Millis, Option, ms, renderOption)
import Internal.Property as P


type Transition
    = Transition (List Property)


type alias Config =
    { duration : Millis, options : List Option }


type Property
    = Property String Millis (List Option)


render : Transition -> String
render (Transition props) =
    List.map renderProperty props
        |> List.intersperse ", "
        |> append


renderProperty : Property -> String
renderProperty (Property name duration options) =
    name
        ++ " "
        ++ ms duration
        ++ (List.concatMap renderOption options |> append)


append : List String -> String
append =
    List.foldl (++) ""


toAttr : Transition -> Html.Attributes msg
toAttr =
    render >> Html.Attributes.style "transition"
