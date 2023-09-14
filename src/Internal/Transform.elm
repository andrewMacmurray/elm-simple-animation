module Internal.Transform exposing
    ( Transform
    , name
    , rotate
    , scale
    , scaleXY
    , toString
    , x
    , xy
    , y
    )

-- Transform


type Transform
    = Translate Translate
    | ScaleXY Float Float
    | Rotate Float


type Translate
    = X Float
    | Y Float
    | XY Float Float


type alias Combined =
    { x : Maybe Float
    , y : Maybe Float
    , xy : Maybe ( Float, Float )
    , scale : Maybe ( Float, Float )
    , rotate : Maybe Float
    }


empty : Combined
empty =
    { x = Nothing
    , y = Nothing
    , xy = Nothing
    , scale = Nothing
    , rotate = Nothing
    }



-- Build


scale : Float -> Transform
scale n =
    ScaleXY n n


scaleXY : Float -> Float -> Transform
scaleXY =
    ScaleXY


x : Float -> Transform
x =
    Translate << X


y : Float -> Transform
y =
    Translate << Y


xy : Float -> Float -> Transform
xy x_ y_ =
    Translate (XY x_ y_)


rotate : Float -> Transform
rotate =
    Rotate



-- To String


toString : List Transform -> String
toString =
    List.foldl combine empty >> render


combine : Transform -> Combined -> Combined
combine transform combined =
    case transform of
        Rotate n ->
            { combined | rotate = Just n }

        ScaleXY x_ y_ ->
            { combined | scale = Just ( x_, y_ ) }

        Translate (XY x_ y_) ->
            { combined | xy = Just ( x_, y_ ) }

        Translate (X n) ->
            { combined | x = Just n }

        Translate (Y n) ->
            { combined | y = Just n }


render : Combined -> String
render combined =
    [ translate_ combined
    , render_ scale_ combined.scale
    , render_ rotate_ combined.rotate
    ]
        |> List.filter (String.isEmpty >> not)
        |> String.join " "


render_ : (transform -> String) -> Maybe transform -> String
render_ f =
    Maybe.map f >> Maybe.withDefault ""


scale_ : ( Float, Float ) -> String
scale_ ( x_, y_ ) =
    String.concat [ "scale3d(", String.fromFloat x_, ",", String.fromFloat y_, ",1)" ]


translate_ : Combined -> String
translate_ combined =
    case ( combined.xy, combined.x, combined.y ) of
        ( Just ( x_, y_ ), _, _ ) ->
            translateXY_ x_ y_

        ( Nothing, Just x_, Nothing ) ->
            translateX_ x_

        ( Nothing, Nothing, Just y_ ) ->
            translateY_ y_

        ( Nothing, Just x_, Just y_ ) ->
            translateXY_ x_ y_

        ( Nothing, Nothing, Nothing ) ->
            ""


translateXY_ : Float -> Float -> String
translateXY_ x_ y_ =
    String.concat [ "translate3d(", px x_, ",", px y_, ",0)" ]


translateX_ : Float -> String
translateX_ n =
    String.concat [ "translate3d(", px n, ",0,0)" ]


translateY_ : Float -> String
translateY_ n =
    String.concat [ "translate3d(0,", px n, ",0)" ]


rotate_ : Float -> String
rotate_ n =
    String.concat [ "rotate3d(0,0,1,", deg n, ")" ]


px : Float -> String
px n =
    if n == 0 then
        "0"

    else
        String.fromFloat n ++ "px"


deg : Float -> String
deg n =
    if n == 0 then
        "0"

    else
        String.fromFloat n ++ "deg"



-- Name


name : Transform -> String
name t =
    case t of
        Translate (Y y_) ->
            "y" ++ rounded 1 y_

        Translate (X x_) ->
            "x" ++ rounded 1 x_

        Translate (XY x_ y_) ->
            "x" ++ rounded 1 x_ ++ "y" ++ rounded 1 y_

        Rotate r_ ->
            "r" ++ rounded 1 r_

        ScaleXY x_ y_ ->
            "sx" ++ rounded 100 x_ ++ "sy" ++ rounded 100 y_


rounded : Int -> Float -> String
rounded n val =
    String.fromInt (round val * n)
