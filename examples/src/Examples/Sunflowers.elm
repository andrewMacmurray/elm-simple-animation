module Examples.Sunflowers exposing (examples)

import Element exposing (..)
import Sunflower
import Utils.UI exposing (..)


examples : Element msg -> Element msg
examples =
    groups [ sunflowers ]


sunflowers : Element msg
sunflowers =
    group "Sunflowers" sunflowers_


sunflowers_ : Element msg
sunflowers_ =
    row [ width (fill |> maximum 600) ]
        [ el [ width fill, moveDown 50, moveRight 50 ]
            (Sunflower.sunflower
                { delay = 200
                , offset = { x = 0, y = 20 }
                }
            )
        , el [ width fill ]
            (Sunflower.sunflower
                { delay = 0
                , offset = { x = 10, y = 80 }
                }
            )
        , el [ width fill, moveDown 50, moveLeft 50 ]
            (Sunflower.sunflower
                { delay = 400
                , offset = { x = -50, y = 30 }
                }
            )
        ]
