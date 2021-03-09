module Examples.Transitions.Tooltips exposing (examples)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Simple.Transition as Transition
import Utils.Transition as Transition
import Utils.UI exposing (blue, groups, medium, white)


examples : Element msg -> Element msg
examples =
    groups [ tooltips ]


tooltips : Element msg
tooltips =
    row [ spacing (medium * 2), paddingXY 0 (medium * 2) ]
        [ textWithTooltip
        , textWithTooltip
        , textWithTooltip
        ]


textWithTooltip : Element msg
textWithTooltip =
    el [ pointer, inFront tooltip, paddingXY 0 medium ] (text "Hover over me")


tooltip : Element msg
tooltip =
    el
        [ width fill
        , height fill
        , alpha 0
        , moveUp 0
        , mouseOver [ alpha 1, moveUp 2 ]
        , Transition.all_ { duration = 300, options = [] }
            [ Transition.opacity
            , Transition.transform
            ]
        ]
        (el
            [ Background.color blue
            , Border.rounded 3
            , moveUp 50
            , Font.color white
            ]
            (el [ paddingXY 20 20 ]
                (el
                    [ centerY
                    , centerX
                    ]
                    (text "helloooo")
                )
            )
        )
