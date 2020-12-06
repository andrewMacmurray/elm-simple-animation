module Animated exposing
    ( ClassName
    , custom
    , div
    , html
    , node
    )

import Html exposing (Html)
import Html.Attributes
import Internal.Animation as Animation exposing (Animation)
import VirtualDom


type alias ClassName =
    String



-- Html


div : Animation -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
div =
    html Html.div


html :
    (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> Animation
    -> List (Html.Attribute msg)
    -> List (Html msg)
    -> Html msg
html =
    node Html.Attributes.class


node :
    (ClassName -> VirtualDom.Attribute msg)
    -> (List (VirtualDom.Attribute msg) -> List (VirtualDom.Node msg) -> VirtualDom.Node msg)
    -> Animation
    -> List (VirtualDom.Attribute msg)
    -> List (VirtualDom.Node msg)
    -> VirtualDom.Node msg
node toClass_ node_ anim attrs els =
    node_ (toClass_ (Animation.name_ anim) :: attrs) (stylesheet_ anim :: els)


custom : (ClassName -> VirtualDom.Node msg -> animated) -> Animation -> animated
custom toAnimated anim =
    toAnimated (Animation.name_ anim) (stylesheet_ anim)


stylesheet_ : Animation -> VirtualDom.Node msg
stylesheet_ anim =
    VirtualDom.node "style" [] [ VirtualDom.text (Animation.stylesheet_ anim) ]
