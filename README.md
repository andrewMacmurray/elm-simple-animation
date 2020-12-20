# Elm Simple Animation

### Stateless animation utils for Elm

## What?

Animate HTML, SVG (or any UI Elements) with declarative animations

```elm
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

## Why?

When you want some typesafe, simple, decorative animations, but you don't need the full power of something like `elm-animator`. The benefits of this are:

+ Animations are `stateless` (from Elm's perspective) so easy to drop in anywhere (no model, update or subscriptions required).
+ Very performant (generates CSS keyframes animations under the hood).

## How?

1 . Define an animation (either `fromTo` or a sequence of `steps`)

```elm
spinAndSlide : Animation
spinAndSlide =
    Animation.steps
        { startAt = [ P.rotate 0, P.x 0 ]
        , options = [ Animation.loop ]
        }
        [ Animation.step 500 [ P.rotate 180, P.x 20 ]
        , Animation.wait 300
        , Animation.step 500 [ P.rotate 360, P.x 0 ]
        ]
```

2 . Render it on the page and let it fly!

```elm
spinningBox : Html msg
spinningBox =
    Animated.div spinAndSlide [ class "spinning-box" ] []
```

## Animating SVG and Elm UI Elements

So you can use your own version of `elm/svg` and `mdgriffith/elm-ui` there are some functions that let you create animated versions:

## Hook into SVG

Give the `Svg.Attributes` `class` function to `Simple.Animated.node`
```elm
animated =
    Simple.Animated.node Svg.Attributes.class
```

Then create any animated SVG element you like!
```elm
svg : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
svg =
    animated Svg.svg


g : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
g =
    animated Svg.g
```

## Hook into Elm UI

Provide these 3 functions to `Simple.Animated.ui`

```elm
animatedUi =
    Simple.Animated.ui
        { behindContent = Element.behindContent
        , htmlAttribute = Element.htmlAttribute
        , html = Element.html
        }
```

Then create animated `Element`s!

```elm
el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
el =
    animatedUi Element.el


column : Animation -> List (Element.Attribute msg) -> List (Element msg) -> Element msg
column =
    animatedUi Element.column
```

You can find many of these common helpers here: https://github.com/andrewMacmurray/elm-simple-animation/blob/main/examples/src/Utils/Animated.elm


## Run Locally

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
