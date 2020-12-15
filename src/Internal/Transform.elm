module Internal.Transform exposing
    ( Transform
    , render
    , rotate
    , scale
    , scaleXY
    , x
    , xy
    , y
    )


type Transform
    = X Float
    | Y Float
    | XY Float Float
    | ScaleXY Float Float
    | Rotate Float


render : List Transform -> String
render =
    List.map fromTransform >> String.join " "


scale : Float -> Transform
scale n =
    ScaleXY n n


scaleXY : Float -> Float -> Transform
scaleXY =
    ScaleXY


x : Float -> Transform
x =
    X


y : Float -> Transform
y =
    Y


xy : Float -> Float -> Transform
xy =
    XY


rotate : Float -> Transform
rotate =
    Rotate


fromTransform : Transform -> String
fromTransform ts =
    case ts of
        Rotate n ->
            rotate_ n

        ScaleXY x_ y_ ->
            scale_ x_ y_

        XY x_ y_ ->
            translate_ x_ y_

        X n ->
            translateX_ n

        Y n ->
            translateY_ n


scale_ : Float -> Float -> String
scale_ x_ y_ =
    join [ "scale(", String.fromFloat x_, ",", String.fromFloat y_, ")" ]


translateX_ : Float -> String
translateX_ n =
    join [ "translateX(", px n, ")" ]


translateY_ : Float -> String
translateY_ n =
    join [ "translateY(", px n, ")" ]


translate_ : Float -> Float -> String
translate_ x_ y_ =
    join [ "translate(", px x_, ",", px y_, ")" ]


rotate_ : Float -> String
rotate_ n =
    join [ "rotateZ(", deg n, ")" ]


join : List String -> String
join =
    String.join ""


px : Float -> String
px n =
    String.fromFloat n ++ "px"


deg : Float -> String
deg n =
    String.fromFloat n ++ "deg"
