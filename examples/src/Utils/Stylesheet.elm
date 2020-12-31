module Utils.Stylesheet exposing (stylesheet)

import Html exposing (Html)


stylesheet : String -> Html msg
stylesheet stylesheet_ =
    Html.node "style" [] [ Html.text stylesheet_ ]
