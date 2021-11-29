# Elm Simple Animation

### Stateless animation utils for Elm

See some examples here: https://elm-simple-animation-examples.surge.sh/

## What?

Animate HTML, SVG (or any UI Elements) with declarative animations and transitions

A working example: https://ellie-app.com/d5nyjJY3Ptna1

```elm
import Html exposing (Html)
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Animated as Animated
import Simple.Animation.Property as P


animatedDot : Html msg
animatedDot =
    Animated.div expandFade [ class "dot" ] []


expandFade : Animation
expandFade =
    Animation.fromTo
        { duration = 2000
        , options = [ Animation.loop ]
        }
        [ P.opacity 1, P.scale 1 ]
        [ P.opacity 0, P.scale 2 ]
```

![dot](https://aws1.discourse-cdn.com/standard17/uploads/elm_lang/original/2X/e/e0cc696d2b443390d5b1ba0e736dbbb1087d3f0b.gif)

## Why?

When you want some typesafe, simple, decorative animations or transitions, but you don't need the full power of something like `elm-animator`. The benefits of this are:

- Animations are `stateless` (from Elm's perspective) so easy to drop in anywhere (no model, update or subscriptions required).
- Very performant
  - `Animations` generate CSS keyframes animations under the hood.
  - `Transitions` are a single Html Attribute with a CSS transition.

## How?

## For Animations:

A working example: https://ellie-app.com/d5nmZJv84f2a1

1 . Define an animation (either `fromTo` or a sequence of `steps`)

```elm
spinAndSlide : Animation
spinAndSlide =
    Animation.steps
        { startAt = [ P.rotate 0, P.x 0 ]
        , options = [ Animation.loop ]
        }
        [ Animation.step 1000 [ P.rotate 180, P.x 50 ]
        , Animation.wait 500
        , Animation.step 1000 [ P.rotate 360, P.x 0 ]
        ]
```

2 . Render it on the page and let it fly!

```elm
spinningBox : Html msg
spinningBox =
    Animated.div spinAndSlide [ class "spinning-box" ] []
```

![spin-and-slide](https://user-images.githubusercontent.com/14013616/103415754-7ae7bc00-4b7b-11eb-8353-66733c2f2209.gif)

## For Transitions

A working example: https://ellie-app.com/d5nxzgtzCpva1

Just add a transition as a Html Attribute

```elm
glowingBox : Html msg
glowingBox =
    div
        [ class "gold-box-on-hover"
        , Transition.properties
            [ Transition.backgroundColor 500 []
            , Transition.color 500 [ Transition.delay 100 ]
            ]
        ]
        [ text "Hover over me" ]
```

![glowing-box](https://user-images.githubusercontent.com/14013616/110212957-c1b4a380-7e95-11eb-9ab9-3d88485496b4.gif)

## Rendering an `Animation` with SVG, Elm UI and Others

So you can use your own version of `elm/svg` and `mdgriffith/elm-ui` (or whatever `Html` abstraction you use) there are some helpers that let you create animated versions:

## Use with SVG

A working example: https://ellie-app.com/fYCGytWFDD7a1

So we can create animated `Svg`s, create an animated wrapper function using `Svg.Attributes.class` and `Simple.Animation.Animated.svg`

```elm
animatedSvg =
    Simple.Animation.Animated.svg
        { class = Svg.Attributes.class
        }
```

This lets you wrap regular `Svg` nodes to make animated ones

```elm
animatedCircle : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
animatedCircle =
    animatedSvg Svg.circle


animatedG : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
animatedG =
    animatedSvg Svg.g
```

Here's an animated circle with `elm/svg`

```elm
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Animated
import Simple.Animation.Property as P
import Svg exposing (Svg)
import Svg.Attributes exposing (cx, cy, r)


myCircle : Svg msg
myCircle =
    animatedCircle fade [ cx "50", cy "50", r "50" ] []


fade : Animation
fade =
    Animation.fromTo
        { duration = 1000
        , options = []
        }
        [ P.opacity 0 ]
        [ P.opacity 1 ]


animatedCircle : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
animatedCircle =
    animatedSvg Svg.circle


animatedSvg =
    Simple.Animation.Animated.svg
        { class = Svg.Attributes.class
        }
```

## Use with Elm UI

A working example: https://ellie-app.com/cZTwvfZ37xWa1

So we can create animated `el`s, `row`s or `column`s, create an animated wrapper function using `Simple.Animation.Animated.ui` and the following `Element` functions:

```elm
animatedUi =
    Simple.Animation.Animated.ui
        { behindContent = Element.behindContent
        , htmlAttribute = Element.htmlAttribute
        , html = Element.html
        }
```

this lets you wrap regular `Element`s to create animated ones:

```elm
animatedEl : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
animatedEl =
    animatedUi Element.el


animatedColumn : Animation -> List (Element.Attribute msg) -> List (Element msg) -> Element msg
animatedColumn =
    animatedUi Element.column
```

Here's an animated square with `elm-ui`:

```elm
import Element exposing (..)
import Element.Background as Background
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Animated as Animated
import Simple.Animation.Property as P


mySquare : Element msg
mySquare =
    animatedEl fade
        [ width (px 30)
        , height (px 30)
        , Background.color (rgb 1 0 0)
        ]
        none


fade : Animation
fade =
    Animation.fromTo
        { duration = 1000
        , options = []
        }
        [ P.opacity 0 ]
        [ P.opacity 1 ]


animatedEl : Animation -> List (Attribute msg) -> Element msg -> Element msg
animatedEl =
    animatedUi Element.el


animatedUi =
    Animated.ui
        { behindContent = Element.behindContent
        , htmlAttribute = Element.htmlAttribute
        , html = Element.html
        }
```

## Use with elm-css

So we can create animated versions of `elm-css` `div`s, `p`s or any other `Styled` element, create an animated wrapper using `Simple.Animation.Animated.elmCss` and the following:

```elm
animatedElmCssNode =
    Animated.elmCss
        { text = Html.Styled.text
        , node = Html.Styled.node
        , class = Html.Styled.Attributes.class
        }
```

this lets you wrap regular `Html.Styled` nodes to create animated ones:

```elm
animatedDiv : Animation -> List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Html.Styled.Html msg
animatedDiv =
    animatedElmCssNode Html.Styled.div


animatedLi : Animation -> List (Html.Styled.Attribute msg) -> List (Html.Styled.Html msg) -> Html.Styled.Html msg
animatedLi =
    animatedElmCssNode Html.Styled.li
```

Here's an animated square using `elm-css`

```elm
import Css
import Html exposing (Html)
import Html.Styled as Styled
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Animated
import Simple.Animation.Property as P
import Html.Styled.Attributes as StyledAttributes


mySquare : Html msg
mySquare =
    Styled.toUnstyled
        (animatedDiv hover
            []
            [ Styled.div
                [ StyledAttributes.css
                    [ Css.width (Css.px 50)
                    , Css.height (Css.px 50)
                    , Css.backgroundColor (Css.hex "ff0000")
                    ]
                ]
                []
            ]
        )


hover : Animation
hover =
    Animation.steps
        { startAt = [ P.y 0 ]
        , options = [ Animation.loop, Animation.easeInOutQuad ]
        }
        [ Animation.step 500 [ P.y 20 ]
        , Animation.step 650 [ P.y 0 ]
        ]


animatedDiv : Animation -> List (Styled.Attribute msg) -> List (Styled.Html msg) -> Styled.Html msg
animatedDiv =
    animatedElmCssNode Styled.div


animatedElmCssNode =
    Simple.Animation.Animated.elmCss
        { text = Styled.text
        , node = Styled.node
        , class = StyledAttributes.class
        }


```

## Use a Custom Renderer

In case you want to completely customise how to render animations you can use the low level `Simple.Animation.Animated.custom` - which gives you access to the raw animation `stylesheet` and `class` name that will apply the animation.

For example, say you wanted to animate `elm-community/typed-svg` nodes - you could create animated versions like this:

```elm
g : Animation -> List (TypedSvg.Attribute msg) -> List (TypedSvg.Svg msg) -> TypedSvg.Svg msg
g =
    animatedTypedSvg TypedSvg.g


animatedTypedSvg node animation attributes children =
    Simple.Animation.Animated.custom
        (\className stylesheet ->
            node
                (TypedSvg.Attributes.class [ className ] :: attributes)
                (TypedSvg.style [] [ TypedSvg.text stylesheet ] :: children)
        )
        animation
```

You can find many of these common helpers here: https://github.com/andrewMacmurray/elm-simple-animation/blob/main/examples/src/Utils/Animated.elm

## Develop Locally

install dependencies

```
$ npm install
```

run the tests

```
$ npm test
```

run the examples

```
$ npm run examples
```
